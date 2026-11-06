// Pages through all inventory items, looks up the offers of each SKU and reports the
// SKUs that have no published offer.

import ballerina/http;
import ballerina/io;
import ballerinax/ebay.inventory;

configurable string accessToken = ?;
configurable int pageSize = 100;

public function main() returns error? {
    inventory:Client ebay = check new ({auth: {token: accessToken}});

    // Step 1: Collect every inventory item, one page at a time
    string[] skus = [];
    int offset = 0;
    while true {
        inventory:InventoryItems page = check ebay->getInventoryItems('limit = pageSize.toString(), offset = offset.toString());
        foreach inventory:InventoryItemWithSkuLocaleGroupid item in page.inventoryItems {
            string? itemSku = item?.sku;
            if itemSku is string {
                skus.push(itemSku);
            }
        }
        if page.inventoryItems.length() < pageSize {
            break;
        }
        offset += pageSize;
    }
    io:println("Inventory items found: ", skus.length());

    // Step 2: Check the offers of each SKU
    string[] unlisted = [];
    foreach string sku in skus {
        inventory:Offers|error offers = ebay->getOffers(sku = sku);
        if offers is error {
            // eBay answers 404 for a SKU with no offers; any other failure stops the audit
            if offers is http:ClientRequestError && offers.detail().statusCode == 404 {
                unlisted.push(sku);
                continue;
            }
            return error(string `Offer lookup failed for SKU ${sku}`, offers);
        }
        boolean hasPublished = offers.offers.some(o => o.status == "PUBLISHED");
        if !hasPublished {
            unlisted.push(sku);
        }
    }

    // Step 3: Report the SKUs without a published offer, with the locations that can stock them
    inventory:LocationResponse locations = check ebay->getInventoryLocations();
    io:println("Inventory locations: ", (locations?.locations ?: []).length());
    io:println("SKUs without a published offer: ", unlisted.length());
    foreach string sku in unlisted {
        io:println("  ", sku);
    }
}
