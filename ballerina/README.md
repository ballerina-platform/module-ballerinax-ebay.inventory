## Overview

The eBay Inventory connector provides programmatic access to the [eBay Sell Inventory API](https://developer.ebay.com/api-docs/sell/inventory/overview.html), which lets sellers create and manage inventory items, product compatibility, inventory item groups, offers and inventory locations. This connector supports version 1.18.8 of the Inventory API and lets Ballerina integrations create listings, update stock and prices in bulk, and publish or withdraw offers on eBay marketplaces.

### Key features

- Create, replace, retrieve and delete inventory items, including bulk operations of up to 25 SKUs per call
- Manage multi-variation listings through inventory item groups and product compatibility lists
- Create, update, publish and withdraw offers, individually or by inventory item group, and preview listing fees
- Maintain inventory locations and map them to listings and SKUs

## Setup guide

1. Sign in to the [eBay Developers Program](https://developer.ebay.com/) and create an application keyset in the Application Keys page.

2. Configure the OAuth redirect URL (RuName) of the application and grant it the `https://api.ebay.com/oauth/api_scope/sell.inventory` scope, or `https://api.ebay.com/oauth/api_scope/sell.inventory.readonly` for read-only access.

3. Complete the authorization code grant flow with the seller account to obtain a user access token and a refresh token.

4. Keep the access token at hand. The connector sends it as a bearer token, or you can configure a refresh token with the client ID and client secret so that the connector renews the access token automatically.

## Quickstart

To use the eBay Inventory connector in your Ballerina application, update the `.bal` file as follows:

**Step 1:** Import the module and declare the configuration.

```ballerina
import ballerinax/ebay.inventory;

configurable string accessToken = ?;
```

**Step 2:** Create a `Config.toml` file with your credentials.

```toml
accessToken = "<your-ebay-user-access-token>"
```

**Step 3:** Create a client.

```ballerina
inventory:Client inventoryClient = check new ({auth: {token: accessToken}});
```

**Step 4:** Call an operation, for example list the inventory items of the seller.

```ballerina
public function main() returns error? {
    inventory:InventoryItems _ = check inventoryClient->getInventoryItems('limit = "10");
}
```

## Examples

The `eBay Inventory` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-ebay.inventory/tree/main/examples/), covering the following use cases:

- [Listing publish workflow](../examples/listing_publish_workflow/listing_publish_workflow.md) - Create an inventory item, draft an offer, preview the listing fees and optionally publish the offer.
- [Stock offer audit](../examples/stock_offer_audit/stock_offer_audit.md) - Page through all inventory items and report the SKUs that have no published offer.
