// Creates an inventory item, drafts an offer for it, previews the listing fees and
// optionally publishes the offer on eBay.

import ballerina/io;
import ballerinax/ebay.inventory;

configurable string accessToken = ?;
configurable string sku = ?;
configurable string categoryId = ?;
configurable string fulfillmentPolicyId = ?;
configurable string paymentPolicyId = ?;
configurable string returnPolicyId = ?;
configurable string merchantLocationKey = ?;
// Product details eBay needs to publish a SKU that is not matched to an eBay catalog product
configurable string[] imageUrls = ?;
configurable map<string[]> aspects = {"Brand": ["Unbranded"]};
configurable string price = "19.99";
configurable int quantity = 10;
configurable boolean publishListing = false;

public function main() returns error? {
    inventory:Client ebay = check new ({auth: {token: accessToken}});
    int:Signed32 stock = <int:Signed32>quantity;

    // Step 1: Create or replace the inventory item
    inventory:BaseResponse? itemResult = check ebay->createOrReplaceInventoryItem(sku,
        {contentLanguage: "en-US", contentType: "application/json"},
        {
            condition: "NEW",
            product: {
                title: "Classic Cotton T-Shirt",
                description: "Soft cotton t-shirt in assorted sizes",
                imageUrls,
                aspects
            },
            availability: {shipToLocationAvailability: {quantity: stock}}
        });
    io:println("Inventory item saved: ", sku, itemResult is () ? " (updated)" : " (created)");

    // Step 2: Draft an offer for the item
    inventory:OfferResponse offer = check ebay->createOffer(
        {contentLanguage: "en-US", contentType: "application/json"},
        {
            sku,
            marketplaceId: "EBAY_US",
            format: "FIXED_PRICE",
            categoryId,
            merchantLocationKey,
            includeCatalogProductDetails: true,
            availableQuantity: stock,
            pricingSummary: {price: {currency: "USD", value: price}},
            listingPolicies: {fulfillmentPolicyId, paymentPolicyId, returnPolicyId}
        });
    string? createdOfferId = offer.offerId;
    if createdOfferId is () {
        return error("eBay did not return an offer ID");
    }
    string offerId = createdOfferId;
    io:println("Offer created: ", offerId);

    // Step 3: Preview the listing fees
    inventory:FeesSummaryResponse fees = check ebay->getListingFees({contentType: "application/json"}, {offers: [{offerId}]});
    foreach inventory:FeeSummary summary in fees.feeSummaries {
        foreach inventory:Fee fee in summary.fees {
            io:println("Fee ", fee.feeType, ": ", fee.amount.value ?: "n/a", " ", fee.amount.currency ?: "");
        }
    }

    // Step 4: Publish the offer when requested
    if !publishListing {
        io:println("Skipping publish; set publishListing = true to list the offer.");
        return;
    }
    inventory:PublishResponse published = check ebay->publishOffer(offerId);
    io:println("Offer published as listing: ", published.listingId ?: "unknown");
}
