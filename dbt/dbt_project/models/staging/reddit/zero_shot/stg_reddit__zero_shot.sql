{{ 
    config(
        materialized='incremental',
        unique_key='id',
        tags=['staging', 'reddit', 'zero_shot']
    ) 
}}

-- global variables so that they can easily be updated
{%- set text_column = 'post_combined_title_description_truncated' -%}
{%- set date_column = 'post_utc_date_created_at' -%}
{%- set zero_shot_text_column = 'zero_shot_text' -%}
{%- set incremental_interval = '3 day' -%}
{%- set other_columns = 'id,post_utc_date_created_at' -%}
{%- set zero_shot_model_path = '/zero_shot/zero_shot_model/' -%}
{%- set seed_value = 42 -%}
{%- set batch_size = 4 -%}
{%- set multi_label_prediction = True -%}

-- select results from zero_shot_features UDF
SELECT * FROM public.zero_shot_features(
    '{{ text_column }}',
    '{{ date_column }}',
    '{{ zero_shot_text_column }}',
    '{{ incremental_interval }}',
    '{{ other_columns }}',
    '{{ ref("stg_reddit__filter_posts") }}',
    {{ is_incremental() }},
    '{{ target.name }}',
    '{{ this }}',
    '{{ zero_shot_model_path }}',
    {{ seed_value }},
    {{ batch_size }},
    {{ multi_label_prediction }}
)
