{%- macro zero_shot_labels(output_schema = True) -%}

{%- for idx in range(var("max_zero_shot_labels")) %}
    {{ "zero_shot_feature_" ~ (idx + 1) }}
    {% if output_schema -%} text{%- endif -%}
    {%- if not loop.last -%},{%- endif -%}
{%- endfor -%}

{%- endmacro -%}
