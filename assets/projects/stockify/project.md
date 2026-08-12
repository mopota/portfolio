# Stockify (E-commerce)

## Overview
**Stockify** is a production-oriented E-commerce application. It demonstrates the ability to build a full-featured commercial platform using **Flutter** and **Firebase**, focusing on real-time data synchronization, secure payments, and robust inventory management.

## Engineering Highlights
- **Cloud-Native Backend:** Built on Firebase, utilizing **Firestore** for real-time catalog management and **Cloud Functions** for server-side business logic.
- **Payment Lifecycle:** Integrated **Stripe** to handle complex checkout flows. This included debugging native plugin issues (e.g., `MissingPluginException`) and ensuring transaction integrity.
- **Inventory Reliability:** Developed custom logic to handle stock races, ensuring that payments are only processed if the inventory is still available at the exact moment of transaction.
- **UI/UX Resilience:** Implemented graceful handling for missing product images and network-related data fetching issues to maintain a high-quality user experience.

## Architecture & Technology
- **Backend:** Firebase (Firestore, Auth, Functions).
- **Frontend:** Flutter.
- **Payments:** Stripe Integration.
- **Security:** Granular Firestore Security Rules to protect user data and financial records.

## Key Features
- **Product Catalog:** Dynamic categories and search.
- **Stock Management:** Real-time inventory tracking.
- **Checkout Flow:** Secure payment gateway integration with Stripe.
- **Security:** Audited rules for data access and integrity.

## Development Context
The project serves as a prime example of building commercial software that accounts for edge cases like race conditions in stock management and the complexities of third-party payment integrations in a multi-platform environment.
