{{ 
  config( 
    materialized = "incremental", 
    unique_key = "id",
    tags = ["staging", "reddit", "preprocess"]
  ) 
}}

SELECT
    *,
    CONCAT(post_title, ' ', post_main_text) AS post_combined_title_description,
    SUBSTRING(
        CONCAT(post_title, ' ', post_main_text), 1, 500
    ) AS post_combined_title_description_truncated
FROM {{ ref("base__reddit_subreddit_data_engineering") }}
WHERE
    post_is_robot_indexable = TRUE
    AND post_removed_by_category IS NULL
    AND LENGTH(post_title) > 0
    AND post_main_text NOT LIKE '[removed]%'
    AND author_username != '[deleted]'
    AND post_is_video = FALSE
    AND post_is_media_only = FALSE

    {% if is_incremental() %}
        -- this filter will only be applied on an incremental run
        AND post_utc_date_created_at >= (
            SELECT MAX(post_utc_date_created_at) - INTERVAL '3 day'
            FROM
                {{ this }})
    {% endif %}
