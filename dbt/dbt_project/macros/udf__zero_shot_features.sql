{% macro zero_shot_features() %}

CREATE OR REPLACE FUNCTION public.zero_shot_features (
    text_column text,
    date_column text,
    zero_shot_text_column text,
    incremental_interval text,
    other_columns text,
    text_table text,
    is_incremental boolean,
    dbt_target text,
    zero_shot_table text,
    zero_shot_model_path text,
    seed_value int,
    batch_size int,
    multi_label_prediction boolean
    )
    RETURNS TABLE (
        id char(6),
        post_utc_date_created_at date,
        {% for col in var('zero_shot_candidate_labels')|sort  %}
            {%- set zero_shot_col = col|lower|replace(' ', '_')|replace('/', '_') -%}
            {{ zero_shot_col ~ " numeric(5,4),"}}
        {% endfor %}
        "zero_shot_text" text
    ) AS $$
import pandas as pd
from zero_shot.zero_shot_classification import candidate_labels_to_columns, model_inference

gpu_id = -1
candidate_labels = {{var("zero_shot_candidate_labels")}}
sorted_zero_shot_columns = candidate_labels_to_columns(candidate_labels)
sorted_zero_shot_columns.append(zero_shot_text_column)
other_columns_list = other_columns.split(",")
sorted_zero_shot_columns = other_columns_list + sorted_zero_shot_columns
select_other_columns_query = (
    ",".join([f"{text_table}.{col}" for col in other_columns_list]) if other_columns_list else ""
)
incremental_query = (
    f"""
WHERE {date_column} >= (
SELECT
    max({date_column}) - interval '{incremental_interval}'
FROM {zero_shot_table}
)
"""
    if is_incremental
    else ""
)
dev_query = (
    f"""
WHERE {date_column} >= CURRENT_DATE - interval '{incremental_interval}'
"""
    if not is_incremental and dbt_target == "dev"
    else ""
)

Q = f"""
SELECT
    {select_other_columns_query},
    {text_table}.{text_column}
FROM
    {text_table}
{incremental_query}
{dev_query}
"""
df = pd.DataFrame.from_records(plpy.execute(Q))

if df.empty:
    df_results = pd.DataFrame(columns=sorted_zero_shot_columns)

else:
    zero_shot_model = model_inference(
        text_docs=df[text_column].values,
        candidate_labels=candidate_labels,
        model=zero_shot_model_path,
        tokeniser=zero_shot_model_path,
        multi_label=multi_label_prediction,
        batch_size=batch_size,
        seed_value=seed_value,
        gpu_id=gpu_id,
        text_column_name=zero_shot_text_column,
    )
    df_results = zero_shot_model.run()

    df_results = df.join(df_results)
    df_results = df_results[sorted_zero_shot_columns]

return df_results.to_records(index=False)

$$
LANGUAGE 'plpython3u';

{% endmacro %}
