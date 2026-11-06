// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api.ebay.com/sell/inventory/v1" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("EBAY_ACCESS_TOKEN") : "test_token";
final string testSku = isLiveServer ? os:getEnv("EBAY_TEST_SKU") : "SKU-1001";

final Client ebay = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

const string LANG = "en-US";
const string JSON_TYPE = "application/json";

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetInventoryItems() returns error? {
    InventoryItems response = check ebay->getInventoryItems('limit = "2", offset = "0");
    test:assertTrue(response.inventoryItems.length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetInventoryItem() returns error? {
    InventoryItemWithSkuLocaleGroupid response = check ebay->getInventoryItem(testSku);
    test:assertEquals(response?.sku, testSku);
}

@test:Config {groups: ["mock_tests"]}
function testCreateOrReplaceInventoryItem() returns error? {
    BaseResponse? response = check ebay->createOrReplaceInventoryItem("SKU-2001",
        {contentLanguage: LANG, contentType: JSON_TYPE},
        {condition: "NEW", product: {title: "Canvas Tote Bag", description: "Durable canvas tote bag"}});
    test:assertTrue(response is ());
}

@test:Config {groups: ["mock_tests"]}
function testDeleteInventoryItem() returns error? {
    string sku = "SKU-3001";
    BaseResponse? _ = check ebay->createOrReplaceInventoryItem(sku, {contentLanguage: LANG, contentType: JSON_TYPE},
        {condition: "NEW", product: {title: "Temporary item", description: "Item created for the delete test"}});
    check ebay->deleteInventoryItem(sku);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testBulkGetInventoryItem() returns error? {
    BulkGetInventoryItemResponse response = check ebay->bulkGetInventoryItem({contentType: JSON_TYPE}, {requests: [{sku: testSku}]});
    test:assertTrue(response.responses.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testBulkCreateOrReplaceInventoryItem() returns error? {
    BulkInventoryItemResponse response = check ebay->bulkCreateOrReplaceInventoryItem(
        {contentLanguage: LANG, contentType: JSON_TYPE},
        {requests: [{sku: "SKU-1001", locale: "en_US", product: {title: "Classic Cotton T-Shirt", description: "Soft cotton t-shirt"}}]});
    test:assertTrue(response.responses.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testBulkUpdatePriceQuantity() returns error? {
    BulkPriceQuantityResponse response = check ebay->bulkUpdatePriceQuantity({contentType: JSON_TYPE},
        {requests: [{sku: "SKU-1001", shipToLocationAvailability: {quantity: 10}}]});
    test:assertEquals(response.responses[0].sku, "SKU-1001");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetProductCompatibility() returns error? {
    Compatibility response = check ebay->getProductCompatibility(testSku);
    test:assertTrue(response.compatibleProducts.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testCreateOrReplaceProductCompatibility() returns error? {
    BaseResponse? response = check ebay->createOrReplaceProductCompatibility("SKU-1001",
        {contentLanguage: LANG, contentType: JSON_TYPE},
        {sku: "SKU-1001", compatibleProducts: [{notes: "Fits all trims"}]});
    test:assertTrue(response is ());
}

@test:Config {groups: ["mock_tests"]}
function testGetInventoryItemGroup() returns error? {
    InventoryItemGroup response = check ebay->getInventoryItemGroup("GROUP-1");
    test:assertEquals(response.inventoryItemGroupKey, "GROUP-1");
}

@test:Config {groups: ["mock_tests"]}
function testCreateOrReplaceInventoryItemGroup() returns error? {
    BaseResponse? _ = check ebay->createOrReplaceInventoryItemGroup("GROUP-1",
        {contentLanguage: LANG, contentType: JSON_TYPE},
        {inventoryItemGroupKey: "GROUP-1", variantSKUs: ["SKU-1001", "SKU-1002"], title: "Classic Cotton T-Shirt"});
}

@test:Config {groups: ["mock_tests"]}
function testDeleteInventoryItemGroup() returns error? {
    string groupKey = "GROUP-2";
    BaseResponse? _ = check ebay->createOrReplaceInventoryItemGroup(groupKey, {contentLanguage: LANG, contentType: JSON_TYPE},
        {inventoryItemGroupKey: groupKey, variantSKUs: ["SKU-3001"], title: "Temporary group"});
    check ebay->deleteInventoryItemGroup(groupKey);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetOffers() returns error? {
    Offers response = check ebay->getOffers(sku = testSku);
    test:assertTrue(response.offers.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testGetOffer() returns error? {
    EbayOfferDetailsWithAll response = check ebay->getOffer("5001");
    test:assertEquals(response.offerId, "5001");
}

@test:Config {groups: ["mock_tests"]}
function testCreateOffer() returns error? {
    OfferResponse response = check ebay->createOffer({contentLanguage: LANG, contentType: JSON_TYPE},
        {sku: "SKU-1001", marketplaceId: "EBAY_US", format: "FIXED_PRICE", includeCatalogProductDetails: true});
    test:assertEquals(response.offerId, "5001");
}

@test:Config {groups: ["mock_tests"]}
function testUpdateOffer() returns error? {
    OfferResponse? response = check ebay->updateOffer("5001", {contentLanguage: LANG, contentType: JSON_TYPE},
        {includeCatalogProductDetails: true, availableQuantity: 30});
    test:assertEquals(response?.offerId, "5001");
}

@test:Config {groups: ["mock_tests"]}
function testDeleteOffer() returns error? {
    OfferResponse created = check ebay->createOffer({contentLanguage: LANG, contentType: JSON_TYPE},
        {sku: "SKU-3001", marketplaceId: "EBAY_US", format: "FIXED_PRICE", includeCatalogProductDetails: true});
    string offerId = created.offerId ?: "";
    check ebay->deleteOffer(offerId);
}

@test:Config {groups: ["mock_tests"]}
function testPublishOffer() returns error? {
    PublishResponse response = check ebay->publishOffer("5001");
    test:assertEquals(response.listingId, "110123456789");
}

@test:Config {groups: ["mock_tests"]}
function testWithdrawOffer() returns error? {
    WithdrawResponse response = check ebay->withdrawOffer("5001");
    test:assertEquals(response.listingId, "110123456789");
}

@test:Config {groups: ["mock_tests"]}
function testGetListingFees() returns error? {
    FeesSummaryResponse response = check ebay->getListingFees({contentType: JSON_TYPE}, {offers: [{offerId: "5001"}]});
    test:assertTrue(response.feeSummaries.length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testBulkCreateOffer() returns error? {
    BulkOfferResponse response = check ebay->bulkCreateOffer({contentLanguage: LANG, contentType: JSON_TYPE},
        {requests: [{sku: "SKU-1001", marketplaceId: "EBAY_US", format: "FIXED_PRICE", includeCatalogProductDetails: true}]});
    test:assertEquals(response.responses[0].offerId, "5001");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
function testGetInventoryLocations() returns error? {
    LocationResponse response = check ebay->getInventoryLocations('limit = "2");
    test:assertTrue((response?.locations ?: []).length() > 0);
}

@test:Config {groups: ["mock_tests"]}
function testGetInventoryLocation() returns error? {
    InventoryLocationResponse response = check ebay->getInventoryLocation("warehouse-east");
    test:assertEquals(response.merchantLocationKey, "warehouse-east");
}

@test:Config {groups: ["mock_tests"]}
function testCreateInventoryLocation() returns error? {
    check ebay->createInventoryLocation("warehouse-west", {contentType: JSON_TYPE},
        {phone: "5551234567", location: {address: {country: "US", stateOrProvince: "CA"}}});
}

@test:Config {groups: ["mock_tests"]}
function testDeleteInventoryLocation() returns error? {
    string key = "store-closed";
    check ebay->createInventoryLocation(key, {contentType: JSON_TYPE},
        {phone: "5551234567", location: {address: {country: "US", stateOrProvince: "CA"}}});
    check ebay->deleteInventoryLocation(key);
}
