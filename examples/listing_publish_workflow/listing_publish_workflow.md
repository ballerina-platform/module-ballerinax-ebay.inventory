# Listing publish workflow

This example creates an inventory item on eBay, drafts a fixed-price offer for it, previews the listing fees and, when requested, publishes the offer as a live listing.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An eBay OAuth user access token with the `https://api.ebay.com/oauth/api_scope/sell.inventory` scope
- An existing merchant location key, a leaf category ID and fulfillment, payment and return policy IDs from your seller account
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<ebay-user-access-token>"
  sku = "<new-sku>"
  categoryId = "<leaf-category-id>"
  fulfillmentPolicyId = "<fulfillment-policy-id>"
  paymentPolicyId = "<payment-policy-id>"
  returnPolicyId = "<return-policy-id>"
  merchantLocationKey = "<merchant-location-key>"
  imageUrls = ["https://<host>/<image>.jpg"]
  aspects = { Brand = ["Unbranded"] }
  price = "19.99"
  quantity = 10
  publishListing = false
  ```
- `imageUrls` (at least one HTTPS image) and `aspects` (the item specifics the category requires, which you can look up with the Taxonomy API's `getItemAspectsForCategory`) are saved with the inventory item. A new SKU with no eBay catalog product identifier (ePID, UPC, ISBN or EAN) has no catalog data to fall back on, so `publishOffer` takes the listing's images and item specifics from these fields. `aspects` defaults to `Brand = ["Unbranded"]` when it is left out.

## Run the example

```bash
bal run
```

Publishing is skipped unless `publishListing` is set to `true`.
