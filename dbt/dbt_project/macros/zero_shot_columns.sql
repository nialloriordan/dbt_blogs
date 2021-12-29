{% macro zero_shot_columns() %}

{%- for col in var('zero_shot_candidate_labels')|sort -%}
    {%- set zero_shot_col = col|lower|replace(' ', '_')|replace('/', '_') -%}
    {%- if not loop.last -%}
        {{ zero_shot_col ~ "," }}
    {%- endif -%}
    {%- if loop.last -%}
        {{ zero_shot_col }}
    {%- endif -%}
{%- endfor -%}

{% endmacro %}
