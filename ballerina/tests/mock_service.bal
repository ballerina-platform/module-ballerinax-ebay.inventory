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

listener http:Listener ep0 = new (9090);

function sampleItem(string sku) returns InventoryItemWithSkuLocaleGroupid => {
    sku,
    locale: "en_US",
    condition: "NEW",
    product: {
        title: "Classic Cotton T-Shirt",
        description: "Soft cotton t-shirt in assorted sizes",
        brand: "Northwind",
        imageUrls: ["https://images.example.org/tshirt-front.jpg"]
    },
    availability: {shipToLocationAvailability: {quantity: 25}}
};

function sampleLocation(string key) returns InventoryLocationResponse => {
    merchantLocationKey: key,
    name: "Main distribution center",
    merchantLocationStatus: "ENABLED",
    locationTypes: ["WAREHOUSE"],
    location: {
        locationId: "loc-" + key,
        address: {addressLine1: "2025 Hamilton Ave", city: "San Jose", stateOrProvince: "CA", postalCode: "95125", country: "US"}
    }
};

function sampleOffer(string offerId, string sku) returns EbayOfferDetailsWithAll => {
    offerId,
    sku,
    marketplaceId: "EBAY_US",
    format: "FIXED_PRICE",
    categoryId: "15724",
    availableQuantity: 25,
    hideBuyerDetails: false,
    includeCatalogProductDetails: true,
    listingDuration: "GTC",
    status: "UNPUBLISHED",
    pricingSummary: {price: {currency: "USD", value: "19.99"}},
    listingPolicies: {fulfillmentPolicyId: "6001", paymentPolicyId: "6002", returnPolicyId: "6003"}
};

@http:ServiceConfig {treatNilableAsOptional: true}
service / on ep0 {
    # Delete an inventory item
    #
    # + sku - This path parameter specifies the seller-defined SKU value of the product whose inventory item record you wish to delete.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-inventory_item-getinventoryitems" target="_blank ">getInventoryItems</a> method to retrieve SKU values.<br><br><strong>Maximum length</strong>: 50
    # + return - returns can be any of following types 
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function delete inventory_item/[string sku]() returns http:NoContent|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Delete an inventory item group
    #
    # + inventoryItemGroupKey - This path parameter specifies the unique identifier of the inventory item group being deleted. This value is assigned by the seller when an inventory item group is created
    # + return - returns can be any of following types 
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function delete inventory_item_group/[string inventoryItemGroupKey]() returns http:NoContent|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Delete an inventory location
    #
    # + merchantLocationKey - This path parameter specifies the unique merchant-defined key (ID) for the inventory location that is to be deleted.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-location-getinventorylocations">getInventoryLocations</a> method to retrieve merchant location keys.<br><br><b>Maximum length</b>: 36
    # + return - returns can be any of following types 
    # http:NoContent (Success)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function delete location/[string merchantLocationKey]() returns http:NoContent|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Delete an offer
    #
    # + offerId - This path parameter specifies the unique identifier of the offer being deleted.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-offer-getoffers">getOffers</a> method to retrieve offer IDs
    # + return - returns can be any of following types 
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function delete offer/[string offerId]() returns http:NoContent|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # List inventory items
    #
    # + 'limit - The value passed in this query parameter sets the maximum number of records to return per page of data. Although this field is a string, the value passed in this field should be an integer from <code>1</code> to <code>200</code>.<br><br><strong>Min:</strong> 1<br><br><strong>Max:</strong> 200<br><br><b>Default:</b> 25
    # + offset - The value passed in this query parameter sets the page number to retrieve. The first page of records has a value of <code>0</code>, the second page of records has a value of <code>1</code>, and so on. If this query parameter is not set, its value defaults to <code>0</code>, and the first page of records is returned. 
    # + return - returns can be any of following types 
    # http:Ok (A paginated list of inventory items)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get inventory_item(string? 'limit, string? offset) returns InventoryItems|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return {
            href: "https://api.ebay.com/sell/inventory/v1/inventory_item?limit=2&offset=0",
            total: 2,
            size: 2,
            'limit: 2,
            inventoryItems: [sampleItem("SKU-1001"), sampleItem("SKU-1002")]
        };
    }

    # Get an inventory item
    #
    # + sku - This path parameter specifies the seller-defined SKU value of the product whose inventory item record you wish to retrieve.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-inventory_item-getinventoryitems" target="_blank ">getInventoryItems</a> method to retrieve SKU values.<br><br><strong>Maximum length</strong>: 50
    # + return - returns can be any of following types 
    # http:Ok (The requested inventory item)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get inventory_item/[string sku]() returns InventoryItemWithSkuLocaleGroupid|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return sampleItem(sku);
    }

    # Get product compatibility
    #
    # + sku - This path parameter specifies the SKU (stock keeping unit) of the inventory item associated with the product compatibility list being retrieved.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-inventory_item-getinventoryitems" target="_blank ">getInventoryItems</a> method to retrieve SKU values
    # + return - returns can be any of following types 
    # http:Ok (The product compatibility list of the inventory item)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get inventory_item/[string sku]/product_compatibility() returns Compatibility|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return {
            sku,
            compatibleProducts: [
                {
                    notes: "Fits all trims",
                    productFamilyProperties: {make: "Toyota", model: "Camry", year: "2019"}
                }
            ]
        };
    }

    # Get an inventory item group
    #
    # + inventoryItemGroupKey - This path parameter specifies the unique identifier of the inventory item group being retrieved. This value is assigned by the seller when an inventory item group is created
    # + return - returns can be any of following types 
    # http:Ok (The requested inventory item group)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get inventory_item_group/[string inventoryItemGroupKey]() returns InventoryItemGroup|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return {
            inventoryItemGroupKey,
            title: "Classic Cotton T-Shirt",
            description: "Soft cotton t-shirt available in several sizes",
            variantSKUs: ["SKU-1001", "SKU-1002"],
            imageUrls: ["https://images.example.org/tshirt-front.jpg"]
        };
    }

    # List inventory locations
    #
    # + 'limit - The value passed in this query parameter sets the maximum number of records to return per page of data. Although this field is a string, the value passed in this field should be a positive integer value. If this query parameter is not set, up to 100 records will be returned on each page of results. <br><br> <strong>Min</strong>: 1
    # + offset - Specifies the number of locations to skip in the result set before returning the first location in the paginated response.  <p>Combine <b>offset</b> with the <b>limit</b> query parameter to control the items returned in the response. For example, if you supply an <b>offset</b> of <code>0</code> and a <b>limit</b> of <code>10</code>, the first page of the response contains the first 10 items from the complete list of items retrieved by the call. If <b>offset</b> is <code>10</code> and <b>limit</b> is <code>20</code>, the first page of the response contains items 11-30 from the complete result set.</p> <p><b>Default:</b> 0</p>
    # + return - returns can be any of following types 
    # http:Ok (A paginated list of inventory locations)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function get location(string? 'limit, string? offset) returns LocationResponse|ErrorBadRequest|ErrorInternalServerError {
        return {
            href: "https://api.ebay.com/sell/inventory/v1/location?limit=2&offset=0",
            total: 2,
            'limit: 2,
            offset: 0,
            locations: [sampleLocation("warehouse-east"), sampleLocation("store-downtown")]
        };
    }

    # Get an inventory location
    #
    # + merchantLocationKey - This path parameter specifies the unique merchant-defined key (ID) for an inventory location that is being retrieved. <br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-location-getinventorylocations">getInventoryLocations</a> method to retrieve merchant location keys. <br><br><b>Maximum length</b>: 36
    # + return - returns can be any of following types 
    # http:Ok (The requested inventory location)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get location/[string merchantLocationKey]() returns InventoryLocationResponse|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return sampleLocation(merchantLocationKey);
    }

    # List offers
    #
    # + format - This enumeration value sets the listing format for the offers being retrieved. This query parameter will be passed in if the seller only wants to see offers in a specified listing format, such as <code>FIXED_PRICE</code>
    # + 'limit - The value passed in this query parameter sets the maximum number of records to return per page of data. Although this field is a string, the value passed in this field should be a positive integer value. If this query parameter is not set, up to 100 records will be returned on each page of results
    # + marketplaceId - The unique identifier of the eBay marketplace. This query parameter will be passed in if the seller only wants to see the product's offers on a specific eBay marketplace.<br><br><span class="tablenote"><strong>Note:</strong> At this time, the same SKU value can not be offered across multiple eBay marketplaces, so the <strong>marketplace_id</strong> query parameter currently does not have any practical use for this call.</span>
    # + offset - The value passed in this query parameter sets the page number to retrieve. Although this field is a string, the value passed in this field should be a integer value equal to or greater than <code>0</code>. The first page of records has a value of <code>0</code>, the second page of records has a value of <code>1</code>, and so on. If this query parameter is not set, its value defaults to <code>0</code>, and the first page of records is returned
    # + sku - The seller-defined SKU value is passed in as a query parameter. All offers associated with this product are returned in the response. <br><br><span class="tablenote"><strong>Note:</strong> The same SKU can be offered through an auction and a fixed-price listing concurrently. If this is the case, <b>getOffers</b> will return two offers. Otherwise, only one offer will be returned.</span><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-inventory_item-getinventoryitems">getInventoryItems</a> method to retrieve SKU values.<br><br><strong>Maximum length</strong>: 50
    # + return - returns can be any of following types 
    # http:Ok (A paginated list of offers)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get offer(string? format, string? 'limit, @http:Query {name: "marketplace_id"} string? marketplaceId, string? offset, string sku) returns Offers|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return {
            href: "https://api.ebay.com/sell/inventory/v1/offer?sku=" + sku,
            total: 1,
            size: 1,
            'limit: 25,
            offers: [sampleOffer("5001", sku)]
        };
    }

    # Get an offer
    #
    # + offerId - This path parameter specifies the unique identifier of the offer that is to be retrieved.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-offer-getoffers">getOffers</a> method to retrieve offer IDs
    # + return - returns can be any of following types 
    # http:Ok (The requested offer)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function get offer/[string offerId]() returns EbayOfferDetailsWithAll|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return sampleOffer(offerId, "SKU-1001");
    }

    # Bulk create offers
    #
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the offer for the channel 
    # + return - returns can be any of following types 
    # http:Ok (Per-offer results of the bulk create request)
    # http:MultiStatus (Multi-Status)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post bulk_create_offer(@http:Header {name: "Content-Language"} string contentLanguage, @http:Header {name: "Content-Type"} string contentType, @http:Payload BulkEbayOfferDetailsWithKeys payload) returns BulkOfferResponseOk|BulkOfferResponseMultiStatus|ErrorBadRequest|ErrorInternalServerError {
        return <BulkOfferResponseOk>{
            body: {
                responses: [
                    {sku: "SKU-1001", marketplaceId: "EBAY_US", format: "FIXED_PRICE", offerId: "5001", statusCode: 200}
                ]
            }
        };
    }

    # Bulk create or replace inventory items
    #
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + payload - Details of the inventories with sku and locale 
    # + return - returns can be any of following types 
    # http:Ok (Per-item results of the bulk create or replace request)
    # http:MultiStatus (Multi-Status)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post bulk_create_or_replace_inventory_item(@http:Header {name: "Content-Type"} string contentType, @http:Header {name: "Content-Language"} string contentLanguage, @http:Payload BulkInventoryItem payload) returns BulkInventoryItemResponseOk|BulkInventoryItemResponseMultiStatus|ErrorBadRequest|ErrorInternalServerError {
        return <BulkInventoryItemResponseOk>{
            body: {
                responses: [
                    {sku: "SKU-1001", locale: "en_US", statusCode: 200},
                    {sku: "SKU-1002", locale: "en_US", statusCode: 200}
                ]
            }
        };
    }

    # Bulk get inventory items
    #
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the inventories with sku and locale 
    # + return - returns can be any of following types 
    # http:Ok (Inventory items and per-item results for the requested SKUs)
    # http:MultiStatus (Multi-Status)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post bulk_get_inventory_item(@http:Header {name: "Content-Type"} string contentType, @http:Payload BulkGetInventoryItem payload) returns BulkGetInventoryItemResponseOk|BulkGetInventoryItemResponseMultiStatus|ErrorBadRequest|ErrorInternalServerError {
        return <BulkGetInventoryItemResponseOk>{
            body: {
                responses: [
                    {
                        sku: "SKU-1001",
                        statusCode: 200,
                        inventoryItem: {
                            sku: "SKU-1001",
                            locale: "en_US",
                            condition: "NEW",
                            product: {title: "Classic Cotton T-Shirt", description: "Soft cotton t-shirt"}
                        }
                    }
                ]
            }
        };
    }

    # Bulk update price and quantity
    #
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Price and allocation details for the given SKU and Marketplace 
    # + return - returns can be any of following types 
    # http:Ok (Per-offer and per-SKU results of the price and quantity update)
    # http:MultiStatus (Multi-Status)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post bulk_update_price_quantity(@http:Header {name: "Content-Type"} string contentType, @http:Payload BulkPriceQuantity payload) returns BulkPriceQuantityResponseOk|BulkPriceQuantityResponseMultiStatus|ErrorBadRequest|ErrorInternalServerError {
        return <BulkPriceQuantityResponseOk>{
            body: {
                responses: [
                    {sku: "SKU-1001", offerId: "5001", statusCode: 200}
                ]
            }
        };
    }

    # Create an inventory location
    #
    # + merchantLocationKey - This path parameter specifies the unique merchant-defined key (ID) for the inventory location that is to be deleted.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-location-getinventorylocations">getInventoryLocations</a> method to retrieve merchant location keys.<br><br><b>Maximum length</b>: 36
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Inventory Location details 
    # + return - returns can be any of following types 
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:Conflict (Location Already Exists)
    # http:InternalServerError (Internal Server Error)
    resource function post location/[string merchantLocationKey](@http:Header {name: "Content-Type"} string contentType, @http:Payload InventoryLocationFull payload) returns http:NoContent|ErrorBadRequest|ErrorConflict|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Create an offer
    #
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the offer for the channel 
    # + return - returns can be any of following types 
    # http:Created (The identifier of the newly created offer)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function post offer(@http:Header {name: "Content-Language"} string contentLanguage, @http:Header {name: "Content-Type"} string contentType, @http:Payload EbayOfferDetailsWithKeys payload) returns OfferResponse|ErrorBadRequest|ErrorInternalServerError {
        return {offerId: "5001"};
    }

    # Publish an offer
    #
    # + offerId - This path parameter specifies the unique identifier of the offer that is to be published.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-offer-getoffers">getOffers</a> method to retrieve offer IDs
    # + return - returns can be any of following types 
    # http:Ok (The listing identifier and any warnings for the published offer)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function post offer/[string offerId]/publish() returns PublishResponseOk|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return <PublishResponseOk>{body: {listingId: "110123456789"}};
    }

    # Withdraw an offer
    #
    # + offerId - This path parameter specifies the unique identifier of the offer that is to be withdrawn.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-offer-getoffers">getOffers</a> method to retrieve offer IDs
    # + return - returns can be any of following types 
    # http:Ok (The listing identifier of the withdrawn offer and any warnings)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function post offer/[string offerId]/withdraw() returns WithdrawResponseOk|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return <WithdrawResponseOk>{body: {listingId: "110123456789"}};
    }

    # Get listing fees for offers
    #
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - List of offers that needs fee information 
    # + return - returns can be any of following types 
    # http:Ok (Listing fees for each of the requested offers)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function post offer/get_listing_fees(@http:Header {name: "Content-Type"} string contentType, @http:Payload OfferKeysWithId payload) returns FeesSummaryResponseOk|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return <FeesSummaryResponseOk>{
            body: {
                feeSummaries: [
                    {
                        marketplaceId: "EBAY_US",
                        fees: [{feeType: "INSERTION_FEE", amount: {currency: "USD", value: "0.35"}}]
                    }
                ]
            }
        };
    }

    # Create or replace an inventory item
    #
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + sku - This path parameter specifies the seller-defined SKU value for the inventory item being created or updated. SKU values must be unique across the seller's inventory. <br><br><strong>Maximum length</strong>: 50
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the inventory item record 
    # + return - returns can be any of following types 
    # http:Ok (Warnings returned after the inventory item was updated)
    # http:Created (Warnings returned after the inventory item was created)
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function put inventory_item/[string sku](@http:Header {name: "Content-Language"} string contentLanguage, @http:Header {name: "Content-Type"} string contentType, @http:Payload InventoryItem payload) returns BaseResponse|BaseResponseCreated|http:NoContent|ErrorBadRequest|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Create or replace product compatibility
    #
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + sku - This path parameter specifies the SKU (stock keeping unit) of the inventory item associated with the compatibility list being created.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-inventory_item-getinventoryitems" target="_blank ">getInventoryItems</a> method to retrieve SKU values
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the compatibility 
    # + return - returns can be any of following types 
    # http:Ok (Warnings returned after the product compatibility was updated)
    # http:Created (Warnings returned after the product compatibility was created)
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function put inventory_item/[string sku]/product_compatibility(@http:Header {name: "Content-Language"} string contentLanguage, @http:Header {name: "Content-Type"} string contentType, @http:Payload Compatibility payload) returns BaseResponse|BaseResponseCreated|http:NoContent|ErrorBadRequest|ErrorInternalServerError {
        return http:NO_CONTENT;
    }

    # Create or replace an inventory item group
    #
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + inventoryItemGroupKey - This path parameter specifies the unique identifier of the inventory item group being created or updated. This identifier is defined by the seller.<br><br>This value cannot be changed once it is set.<br><br><b>Maximum length:</b> 50
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the inventory Item Group 
    # + return - returns can be any of following types 
    # http:Ok (Warnings returned after the inventory item group was updated)
    # http:Created (Warnings returned after the inventory item group was created)
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:InternalServerError (Internal Server Error)
    resource function put inventory_item_group/[string inventoryItemGroupKey](@http:Header {name: "Content-Language"} string contentLanguage, @http:Header {name: "Content-Type"} string contentType, @http:Payload InventoryItemGroup payload) returns BaseResponse|BaseResponseCreated|http:NoContent|ErrorBadRequest|ErrorInternalServerError {
        return <BaseResponseCreated>{body: {}, headers: {}};
    }

    # Update an offer
    #
    # + contentLanguage - This header sets the natural language that will be used in the field values of the request payload. For example, the value passed in this header should be <code>en-US</code> for English or <code>de-DE</code> for German
    # + offerId - This path parameter specifies the unique identifier of the offer being updated.<br><br>Use the <a href="/develop/api/sell/inventory_api#sell-inventory_api-offer-getoffers">getOffers</a> method to retrieve offer IDs
    # + contentType - This header indicates the format of the request body provided by the client. Its value should be set to <b>application/json</b>
    # + payload - Details of the offer for the channel 
    # + return - returns can be any of following types 
    # http:Ok (Warnings returned after the offer was updated)
    # http:NoContent (No Content)
    # http:BadRequest (Bad Request)
    # http:NotFound (Not Found)
    # http:InternalServerError (Internal Server Error)
    resource function put offer/[string offerId](@http:Header {name: "Content-Language"} string contentLanguage, @http:Header {name: "Content-Type"} string contentType, @http:Payload EbayOfferDetailsWithId payload) returns OfferResponse|http:NoContent|ErrorBadRequest|ErrorNotFound|ErrorInternalServerError {
        return {offerId};
    }
}

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type BaseResponseCreated record {|
    *http:Created;
    BaseResponse body;
    record {|string Content\-Language?;|} headers;
|};

public type BulkGetInventoryItemResponseMultiStatus record {|
    *http:MultiStatus;
    BulkGetInventoryItemResponse body;
|};

public type BulkGetInventoryItemResponseOk record {|
    *http:Ok;
    BulkGetInventoryItemResponse body;
|};

public type BulkInventoryItemResponseMultiStatus record {|
    *http:MultiStatus;
    BulkInventoryItemResponse body;
|};

public type BulkInventoryItemResponseOk record {|
    *http:Ok;
    BulkInventoryItemResponse body;
|};

public type BulkOfferResponseMultiStatus record {|
    *http:MultiStatus;
    BulkOfferResponse body;
|};

public type BulkOfferResponseOk record {|
    *http:Ok;
    BulkOfferResponse body;
|};

public type BulkPriceQuantityResponseMultiStatus record {|
    *http:MultiStatus;
    BulkPriceQuantityResponse body;
|};

public type BulkPriceQuantityResponseOk record {|
    *http:Ok;
    BulkPriceQuantityResponse body;
|};

public type ErrorBadRequest record {|
    *http:BadRequest;
    Error body;
|};

public type ErrorConflict record {|
    *http:Conflict;
    Error body;
|};

public type ErrorInternalServerError record {|
    *http:InternalServerError;
    Error body;
|};

public type ErrorNotFound record {|
    *http:NotFound;
    Error body;
|};

public type FeesSummaryResponseOk record {|
    *http:Ok;
    FeesSummaryResponse body;
|};

public type PublishResponseOk record {|
    *http:Ok;
    PublishResponse body;
|};

public type WithdrawResponseOk record {|
    *http:Ok;
    WithdrawResponse body;
|};

# This type defines the fields that can be returned in an error
public type Error record {
    # Name for the primary system where the error occurred. This is relevant for application errors
    string domain?;
    # Further helps indicate which subsystem the error is coming from. System subcategories include: Initialization, Serialization, Security, Monitoring, Rate Limiting, etc
    string subdomain?;
    # An array of request elements most closely associated to the error
    string[] outputRefIds?;
    # A unique number to identify the error
    int:Signed32 errorId?;
    # An array of request elements most closely associated to the error
    string[] inputRefIds?;
    # Identifies the type of erro
    string category?;
    # A more detailed explanation of the error
    string longMessage?;
    # Information on how to correct the problem, in the end user's terms and language where applicable
    string message?;
    # An array of name/value pairs that describe details the error condition. These are useful when multiple errors are returned
    ErrorParameter[] parameters?;
};

# A name-value pair describing an input parameter that is associated with an error
public type ErrorParameter record {
    # Name of the entity that threw the error
    string name?;
    # A description of the error
    string value?;
};
