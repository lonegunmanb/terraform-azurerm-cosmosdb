package upgrade

import (
	"fmt"
	"log"
	"os"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestUpgrade(t *testing.T) {
	directories, err := os.ReadDir("../../examples")
	if err != nil {
		log.Fatal(err)
	}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		_ = os.Setenv("TF_VAR_managed_identity_principal_id", managedIdentityId)
	}
	currentRoot, err := test_helper.GetCurrentModuleRootPath()
	if err != nil {
		t.FailNow()
	}
	currentMajorVersion, err := test_helper.GetCurrentMajorVersionFromEnv()
	if err != nil {
		t.FailNow()
	}
	for _, d := range directories {
		if !d.IsDir() {
			continue
		}
		t.Run(d.Name(), func(t *testing.T) {
			retryCfg, err := os.ReadFile("../retryable_errors.hcl.json")
			if err != nil {
				t.Fatalf(err.Error())
			}
			test_helper.ModuleUpgradeTest(t, "Azure", "terraform-azurerm-cosmosdb", fmt.Sprintf("examples/%s", d.Name()), currentRoot, terraform.Options{
				Upgrade:                  true,
				RetryableTerraformErrors: test_helper.ReadRetryableErrors(retryCfg, t),
			}, currentMajorVersion)
		})
	}
}
