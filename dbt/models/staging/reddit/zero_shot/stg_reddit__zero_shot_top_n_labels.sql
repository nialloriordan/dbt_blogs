{{ 
    config(
        materialized='incremental',
        unique_key='id',
        tags=['staging', 'reddit', 'zero_shot']
    ) 
}}

-- global variables so that they can easily be updated
{%- set text_column = 'zero_shot_text' -%}
{%- set date_column = 'post_utc_date_created_at' -%}
{%- set incremental_interval = '3 day' -%}
{%- set exclude_columns = 'id,post_utc_date_created_at,zero_shot_text' -%}

-- select results from zero_shot_features UDF
SELECT * FROM public.top_n_columns(
    '{{ ref("stg_reddit__zero_shot") }}',
    '{{ var("max_zero_shot_labels") }}',
    '{{ exclude_columns }}',
    '{{ text_column }}',
    '{{ date_column }}',
    '{{ this }}',
    {{ is_incremental() }},
    '{{ incremental_interval }}'
)
