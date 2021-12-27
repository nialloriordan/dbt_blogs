{% macro top_n_columns() %}

CREATE OR REPLACE FUNCTION public.top_n_columns (
    table_reference text,
    n int,
    exclude_columns text,
    text_column text,
    date_column text,
    top_n_table text,
    is_incremental bool,
    incremental_interval text
    )
    RETURNS TABLE (
        id char(6),
        post_utc_date_created_at date,
        {{ zero_shot_labels() }}
    ) AS $$
import pandas as pd

top_n_columns = [f"zero_shot_feature_{idx}" for idx in range(n)]
exclude_columns_list = exclude_columns.split(",")

incremental_query = (
    f"""
WHERE {date_column} >= (
SELECT
    max({date_column}) - interval '{incremental_interval}'
FROM {top_n_table}
)
"""
    if is_incremental
    else ""
)

Q = f"""
SELECT *
FROM
    {table_reference}
{incremental_query}
"""
df = pd.DataFrame.from_records(plpy.execute(Q))

if df.empty:
    exclude_columns_list.remove(text_column)
    df_results = pd.DataFrame(columns=(exclude_columns_list + top_n_columns))

else:
    df_filtered = df[df.columns.drop(exclude_columns_list)]
    df_filtered = df_filtered.apply(pd.to_numeric)
    df_t=pd.DataFrame(df_filtered).T

    df_top_n = pd.DataFrame(columns=top_n_columns)
    for i in df_t.columns:
        df_row = pd.DataFrame(df_t.nlargest(n, i).index.tolist(), index=top_n_columns).T
        df_top_n = pd.concat([df_top_n, df_row], axis=0)

    df_top_n.reset_index(drop=True, inplace=True)
    df_results = df.join(df_top_n)
    exclude_columns_list.remove(text_column)
    df_results = df_results[(exclude_columns_list + top_n_columns)]

return df_results.to_records(index=False)

$$
LANGUAGE 'plpython3u';

{% endmacro %}
