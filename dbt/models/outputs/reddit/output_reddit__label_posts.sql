{{ 
    config(
        materialized='incremental',
        unique_key='id',
        tags=['staging', 'reddit', 'zero_shot']
    ) 
}}

SELECT
    zero_shot_labels.id,
    zero_shot_labels.post_utc_date_created_at,
    base_zero_shot.author_title,
    base_zero_shot.post_title,
    base_zero_shot.post_main_text,
    {{ zero_shot_labels(output_schema = False) }}

FROM {{ ref("stg_reddit__zero_shot_top_n_labels") }} AS zero_shot_labels
LEFT JOIN {{ ref("base__reddit_subreddit_data_engineering") }} AS base_zero_shot
    ON base_zero_shot.id = zero_shot_labels.id
