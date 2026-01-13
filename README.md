# Power BI to REDCap Custom Connector

This repository contains a **custom Power BI data connector** that enables integration with a **REDCap** installation. This connector supports **all REDCap project types**, including:

- Classic and longitudinal projects  
- Projects with **repeating instruments and repeating events**
- Projects with Data Access Groups (DAGs)
- Projects with survey fields

This connector uses the REDCap API to securely retrieve project data directly into Power BI for analysis and visualisation.


## Features

- Connects to any REDCap instance with API access enabled
- Supports **raw or label** formats for both data and headers
- Handles **checkbox fields**, **survey metadata**, and **DAGs**
- Optional filtering by **fields**, **forms**, and **events**
- Works with **Power BI Desktop** and **Power BI Service** (with gateway)


## Required Parameters

When connecting Power BI to REDCap, you must provide the following parameters:

| Parameter | Description | Accepted Values |
|---------|------------|----------------|
| **REDCap URL** | Base URL of your REDCap installation (must start with HTTPS) | `https://...` |
| **Project API Token** | API token generated from the REDCap project | String |
| **Data Format** | Format of exported data values | `raw` or `label` |
| **Header Format** | Format of column headers | `raw` or `label` |
| **Export Checkbox Labels** | Export checkbox labels instead of coded values | `true` or `false` |
| **Export Survey Fields** | Include survey-related fields | `true` or `false` |
| **Export Data Access Groups** | Include Data Access Group information | `true` or `false` |


## Optional Parameters

You may optionally restrict the export using the following parameters:

| Parameter | Description |
|---------|------------|
| **Fields** | Comma-separated list of REDCap field names |
| **Forms** | Comma-separated list of REDCap instruments |
| **Events** | Comma-separated list of event names (for longitudinal projects) |

If optional parameters are not provided, **all available data** will be returned.

---

## Example Connection

```text
REDCap URL: https://redcap.example.org/api/
Project API Token: ABC123XYZ
Data Format: raw
Header Format: label
Export Checkbox Labels: true
Export Survey Fields: false
Export Data Access Groups: true
Fields: age,gender,visit_date
Forms: demographics,follow_up
Events: baseline_arm_1
