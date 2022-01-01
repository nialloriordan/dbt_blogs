{% macro create_udfs() %}

-- drop function as outputs may have changed
DROP FUNCTION IF EXISTS public.top_n_columns;

-- create zero shot feature function
{{ zero_shot_features() }};

-- create top n columns function
{{ top_n_columns() }};

{% endmacro %}
