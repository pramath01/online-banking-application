# Secure Online Banking Application

## About

A secure banking system (SBS) is a software system developed primarily to facilitate secure banking transactions and user account management through the Internet. A banking organization often needs to track various operations performed by both the internal and external users using the organization’s banking infrastructure. The focus of this project is to develop a SBS to facilitate secure banking transactions and account management required by any banking organization.

This repository is a fork of [ajkulkarni/online-banking-application](https://github.com/ajkulkarni/online-banking-application). The primary focus of this fork is to reverse-engineer the correct database schema, stabilize the system architecture, and resolve numerous bugs and inconsistencies present in the original codebase.

Please note that this project is a work in progress. Some features may not be fully functional, and others may cause unexpected errors as the system is still under active development and debugging.

## Technology Stack

*   **Backend:** Java 8, Spring MVC
*   **Frontend:** JSP (JavaServer Pages), HTML, CSS, JavaScript
*   **Database:** MySQL
*   **Build Tool:** Apache Maven
*   **Server:** Apache Tomcat 9.0

---

## Installation Guide

### Prerequisites

Ensure you have the following software installed:
*   **Java Development Kit (JDK):** Version `1.8.0_202` (use this version only)
*   **Apache Maven:** Version `3.9.8` (use this version only)
*   **MySQL Server:** Version `8.0`
*   **Apache Tomcat:** Version `9.0`

### Setup Instructions

Follow these steps carefully to get the application running locally.

**1. Clone the repo to your machine**

**2. Import as a Maven project in IntelliJ/Eclipse**

**3. Database Setup**
   Create a new MySQL database and run all the scripts located in the `/database_scripts` folder. This will create the required tables and populate initial test data.

**4. Configure Database Connection**
   Update the application's database properties file to point to your new database.
   *   **File:** `src/main/resources/jdbc/config/database.properties`

**5. Generate Keystore for Encryption**
   The application requires a `mykeystore.jks` file for encrypting sensitive data. To generate your own:
   *   Delete the existing placeholder `mykeystore.jks` file from `/src/main/resources/`.
   *   Open a terminal in the `/src/main/resources/` directory.
   *   Run the following command:
     ```bash
     keytool -genseckey -alias mykey -keyalg AES -keysize 256 -keystore mykeystore.jks -storetype JCEKS -storepass password -keypass password
     ```

**6.  Configure Google reCAPTCHA**
   To enable the reCAPTCHA on the login page, you need to get your own API keys.
   *   **Get Your Keys:** Visit the [Google reCAPTCHA v2 Admin Console](https://www.google.com/recaptcha/admin/create), register `localhost`, and get your **Site Key** and **Secret Key**.
   *   **Update the Login Page:**
     *   **File:** `WebContent/WEB-INF/LoginPage.jsp`
     *   Around line 98, find `<div class="g-recaptcha" data-sitekey="YOUR_SITE_KEY_HERE"></div>` and replace `YOUR_SITE_KEY_HERE` with your **Site Key**.
   *   **Update the Backend Logic:**
     *   **Note:** Do not do this backend logic step if you are logging in continuously for development purposes. The steps above are for displaying the feature. If you only do the first two steps, you can simply log in without solving the CAPTCHA. If you complete this third step, the CAPTCHA must be solved correctly to log in.
     *   **File:** `src/org/thothlab/devilsvault/controllers/security/VerifyRecaptcha.java`
     *   Update the `SECRET_KEY` variable with your **Secret Key**.

**7. Configure and Run in IntelliJ IDEA**
   *   **Configure Project Structure:**
     *   Select **File -> Project Structure**.
     *   In **Project Settings -> Project**, set the SDK to your JDK 1.8 installation path.
     *   In **Modules -> Dependencies -> Module SDK**, set the SDK to your JDK 1.8 installation path.
   *   **Configure IntelliJ to run a Maven build before starting the server:**
     *   Select **"Run"** in the menu bar and click on **"Edit Configurations..."**.
     *   Click the **`+`** icon and select **"Smart Tomcat"**.
     *   Give it a name (e.g., "Tomcat 9").
     *   Click **"Configure..."** and point it to your Tomcat 9 installation directory.
     *   Go to the **"Server"** tab.
     *   Find the **"Before launch"** section at the bottom.
     *   Click the **`+`** icon, select **"Run Maven Goal"**.
     *   In the "Command line" field, type **`clean install`**.
     *   Click **OK**.
   *   You can now run the application by clicking the "Run" button.
![screenshot](images/Screenshot%202025-07-29%20184804.png)



## Login Credentials

*   **Username:** `manager@bank.com`
*   **Password:** `adminpass`

*   The above username and password are inserted directly using the database scripts. The password is stored as a BCrypt hash.
*   After successfully registering a new user, the password will be displayed in the server log/console, since the email/SMTP service is commented out. You can use those credentials to log in as a customer or merchant.
*   **Note:** Admin login (`admin@bank.com`) is not yet tested properly.

![screenshot](images/Screenshot%202025-07-29%20185542.png)
![screenshot](images/Screenshot%202025-07-29%20184950.png)




