# Architecture <!-- omit in toc -->

## Table of Contents <!-- omit in toc -->
- [postgres](#postgres)
- [dbt](#dbt)

## postgres

A custom postgres container is used to enable Database Analytics by loading machine learning requirements such as Python, Pandas, Pytorch and HuggingFace.

## dbt

dbt also known as data build tool is used as our transformation layer. This enables us to convert raw data in our database into their final format for further analysis.

dbt also allows us to trigger our machine learning models thanks to our custom postgres database and our UDFs.