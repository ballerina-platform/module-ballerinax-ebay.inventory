# Ballerina eBay Inventory connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-ebay.inventory/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.inventory/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-ebay.inventory.svg)](https://github.com/ballerina-platform/module-ballerinax-ebay.inventory/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/ebay.inventory.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Febay.inventory)

## Overview

The eBay Inventory connector provides programmatic access to the [eBay Sell Inventory API](https://developer.ebay.com/api-docs/sell/inventory/overview.html), which lets sellers create and manage inventory items, product compatibility, inventory item groups, offers and inventory locations. This connector supports version 1.18.8 of the Inventory API and lets Ballerina integrations create listings, update stock and prices in bulk, and publish or withdraw offers on eBay marketplaces.



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

- [Listing publish workflow](examples/listing_publish_workflow/listing_publish_workflow.md) - Create an inventory item, draft an offer, preview the listing fees and optionally publish the offer.
- [Stock offer audit](examples/stock_offer_audit/stock_offer_audit.md) - Page through all inventory items and report the SKUs that have no published offer.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`ebay.inventory` package](https://central.ballerina.io/ballerinax/ebay.inventory/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
