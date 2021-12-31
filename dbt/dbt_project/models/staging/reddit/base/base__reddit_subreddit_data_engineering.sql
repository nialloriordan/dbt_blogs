
{{ 
  config( 
    materialized = "incremental", 
    unique_key = "id",
    tags = ["staging", "reddit", "preprocess"]
  ) 
}}

SELECT
    id AS id,
    allow_live_comments AS post_allow_live_comments,
    author AS author_username,
    author_flair_text AS author_title,
    author_flair_type AS author_flair_type,
    author_fullname AS author_id,
    author_is_blocked AS author_is_blocked,
    author_patreon_flair AS author_has_patreon_flair,
    author_premium AS author_is_premium_user,
    can_mod_post AS post_allows_mod_posts,
    contest_mode AS post_is_contest_mode,
    domain AS post_domain,
    full_link AS post_link_reddit,
    is_created_from_ads_ui AS post_is_created_from_ads_ui,
    is_crosspostable AS post_is_crosspostable,
    is_meta AS post_is_meta,
    is_original_content AS post_is_marked_as_original_content,
    is_reddit_media_domain AS post_is_reddit_media_domain,
    is_robot_indexable AS post_is_robot_indexable,
    is_self AS post_is_not_link,
    is_video AS post_is_video,
    link_flair_background_color AS post_flair_background_colour,
    link_flair_template_id AS post_flair_template_id,
    link_flair_text AS post_flair_text,
    link_flair_text_color AS post_flair_text_color,
    link_flair_type AS post_flair_type,
    locked AS post_is_locked_by_mod,
    media_only AS post_is_media_only,
    no_follow AS unknown_col_no_follow,
    num_comments AS post_num_comments,
    over_18 AS post_nsfw,
    parent_whitelist_status AS unknown_col_parent_whitelist_status,
    permalink AS post_permalink,
    pinned AS post_is_pinned,
    score AS post_vote_score,
    selftext AS post_main_text,
    send_replies AS author_receive_post_reply_notifications,
    spoiler AS post_is_spoiler,
    stickied AS post_is_stickied,
    subreddit AS subreddit_name,
    subreddit_id AS subreddit_id,
    subreddit_type AS subreddit_type,
    thumbnail AS post_thumbnail_url,
    title AS post_title,
    upvote_ratio AS post_upvote_ratio,
    url AS post_link_reddit_or_exteranl,
    whitelist_status AS post_whitelist_status,
    post_hint AS post_category,
    url_overridden_by_dest AS post_url_overridden_by_dest,
    removed_by_category AS post_removed_by_category,
    author_flair_background_color AS author_flair_background_color,
    author_flair_template_id AS author_flair_template_id,
    author_flair_text_color AS author_flair_text_color,
    author_cakeday AS author_is_reddit_anniversary,
    crosspost_parent AS post_crosspost_parent,
    banned_by AS post_banned_by,
    is_gallery AS post_is_gallery,
    distinguished AS post_distinguishment,
    removed_by AS post_removed_by,
    og_description AS post_meta_tag_og_description,
    og_title AS post_meta_tag_og_title,
    rte_mode AS author_used_rte_mode,
    author_id AS author_id_legacy,
    brand_safe AS subreddit_is_brand_safe,
    CAST(
        CASE WHEN author_flair_css_class = 'mod' THEN
            1
            ELSE
                0
        END AS boolean) AS author_is_mod,
    TO_TIMESTAMP(
        created_utc
    ) AS post_utc_time_created_at,
    TO_TIMESTAMP(
        created_utc
    )::DATE AS post_utc_date_created_at,
    CAST(num_crossposts AS INT) AS post_num_crossposts,
    TO_TIMESTAMP(retrieved_on) AS post_ingested_at,
    CAST(
        subreddit_subscribers AS int
    ) AS subreddit_num_subscribers,
    COALESCE(
        CAST(total_awards_received AS int), 0
    ) AS post_and_comments_num_awards_received,
    CAST(thumbnail_height AS int) AS post_thumbnail_height,
    CAST(thumbnail_width AS int) AS post_thumbnail_width,
    TO_TIMESTAMP(edited) AS post_edited_at,
    TO_TIMESTAMP(updated_utc) AS post_utc_updated_at,
    COALESCE(
        CAST(gilded AS int), 0
    ) AS post_num_awards_received,
    TO_TIMESTAMP(author_created_utc) AS author_utc_created_at
FROM
    {{ source('blog_scraper' , 'reddit_de') }}

{% if is_incremental() %}
    WHERE TO_TIMESTAMP(created_utc)::DATE >= (
        SELECT MAX(post_utc_date_created_at) - INTERVAL '3 day'
        FROM
            {{ this }}
        )
{% endif %}
