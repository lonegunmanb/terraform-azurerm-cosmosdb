package e2e

import (
	"encoding/json"
	"fmt"
	"io"
	"log"
	"os"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamples(t *testing.T) {
	directories, err := os.ReadDir("../../examples")
	if err != nil {
		log.Fatal(err)
	}
	managedIdentityId := os.Getenv("MSI_ID")
	if managedIdentityId != "" {
		_ = os.Setenv("TF_VAR_managed_identity_principal_id", managedIdentityId)
	}
	retryableErrors := readRetryableErrors(t)

	for _, d := range directories {
		if !d.IsDir() {
			continue
		}
		t.Run(d.Name(), func(t *testing.T) {
			test_helper.RunE2ETest(t, "../../", fmt.Sprintf("examples/%s", d.Name()), terraform.Options{
				Upgrade:                  true,
				RetryableTerraformErrors: retryableErrors,
				// Parallelism: 1,
			}, func(t *testing.T, output test_helper.TerraformOutput) {
				cosmosdbAccountId := output["cosmosdb_account_id"]
				assert.Regexp(t, "/subscriptions/.+/resourceGroups/.+/providers/Microsoft.DocumentDB/databaseAccounts/.+", cosmosdbAccountId)
			})
		})
	}
}

func readRetryableErrors(t *testing.T) map[string]string {
	jsonFile, err := os.Open("../retryable_errors.hcl.json")
	// if we os.Open returns an error then handle it
	if err != nil {
		t.Fatalf("cannot find retryable_errors.hcl.json")
	}
	fmt.Println("Successfully Opened users.json")
	// defer the closing of our jsonFile so that we can parse it later on
	defer func() {
		_ = jsonFile.Close()
	}()

	byteValue, _ := io.ReadAll(jsonFile)
	var cfg map[string]interface{}
	err = json.Unmarshal(byteValue, &cfg)
	if err != nil {
		t.Fatalf("cannot unmarshal retryable_errors.hcl.json")
	}
	retryableRegexes := cfg["retryable_errors"].([]interface{})
	retryableErrors := make(map[string]string)
	for _, r := range retryableRegexes {
		retryableErrors[r.(string)] = "retryable errors set in retryable_errors.hcl.json"
	}
	return retryableErrors
}
