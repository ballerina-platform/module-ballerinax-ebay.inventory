# Examples

The `ballerinax/ebay.inventory` connector provides practical examples illustrating usage in various scenarios.

1. [Listing publish workflow](./listing_publish_workflow/listing_publish_workflow.md) - Create an inventory item, draft an offer, preview the listing fees and optionally publish the offer.
2. [Stock offer audit](./stock_offer_audit/stock_offer_audit.md) - Page through all inventory items and report the SKUs that have no published offer.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An eBay OAuth user access token with the `sell.inventory` scope (`sell.inventory.readonly` is enough for read-only examples)

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
