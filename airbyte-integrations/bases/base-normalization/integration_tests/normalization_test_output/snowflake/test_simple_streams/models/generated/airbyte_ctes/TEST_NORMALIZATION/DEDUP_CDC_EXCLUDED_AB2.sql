{{ config(
    cluster_by = ["_AIRBYTE_EMITTED_AT"],
    unique_key = env_var('AIRBYTE_DEFAULT_UNIQUE_KEY', '_AIRBYTE_AB_ID'),
    schema = "_AIRBYTE_TEST_NORMALIZATION",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to cast each column to its adequate SQL type converted from the JSON schema type
select
    cast(ID as {{ dbt_utils.type_bigint() }}) as ID,
    cast(NAME as {{ dbt_utils.type_string() }}) as NAME,
    cast(_AB_CDC_LSN as {{ dbt_utils.type_float() }}) as _AB_CDC_LSN,
    cast(_AB_CDC_UPDATED_AT as {{ dbt_utils.type_float() }}) as _AB_CDC_UPDATED_AT,
    cast(_AB_CDC_DELETED_AT as {{ dbt_utils.type_float() }}) as _AB_CDC_DELETED_AT,
    _AIRBYTE_AB_ID,
    _AIRBYTE_EMITTED_AT,
    {{ current_timestamp() }} as _AIRBYTE_NORMALIZED_AT
from {{ ref('DEDUP_CDC_EXCLUDED_AB1') }}
-- DEDUP_CDC_EXCLUDED
where 1 = 1
{{ incremental_clause('_AIRBYTE_EMITTED_AT') }}

