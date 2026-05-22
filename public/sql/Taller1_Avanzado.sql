-- =====================================================================
-- 03_template_entrega_taller1_v2.sql
-- Taller aplicado 1 - SQL avanzado + Transacciones (ACID) aplicado
-- Plantilla de entrega para estudiantes
--
-- IMPORTANTE:
-- 1. Trabajar únicamente sobre las tablas T1_% y AUDIT_SALARY_ADJUSTMENTS_T1
-- 2. NO modificar la estructura del entorno entregado por el docente
-- 3. NO eliminar secciones de esta plantilla
-- 4. Reemplazar únicamente los bloques indicados como "ESCRIBA AQUÍ"
-- 5. Usar la variante asignada por el docente (1, 2, 3 o 4)
-- 6. Usar un tag único de ejecución final, por ejemplo: P03_FINAL
-- =====================================================================

SET SERVEROUTPUT ON
SET FEEDBACK ON

-- ============================================================
-- 0. ENCABEZADO OBLIGATORIO
-- Complete toda esta información antes de ejecutar el script.
-- ============================================================
-- Integrante 1: Javier Alejandro García Ospina
-- Integrante 2: Juan Andrés Orjuela Bello
-- Curso: Bases de Datos 1
-- Fecha: 19 de Mayo de 2026
-- Variante asignada por el docente (1, 2, 3 o 4): 3
-- Tag de ejecución final (ejemplo: P03_FINAL): P03_FINAL

DEFINE p_variant_id = 3
DEFINE p_execution_tag = 'P03_FINAL'

PROMPT ===== 0. VERIFICACIÓN DE LA VARIANTE ASIGNADA =====
SELECT
    variant_id,
    variant_name,
    excluded_department_id,
    min_years_service,
    recent_job_history_months,
    gap_high_threshold_pct,
    gap_mid_threshold_pct,
    raise_high_pct,
    raise_mid_pct,
    raise_low_pct,
    max_salary_vs_avg_pct,
    notes
FROM t1_variants
WHERE variant_id = &p_variant_id;

-- ============================================================
-- GUÍA RÁPIDA DE OBJETOS DISPONIBLES
-- Use estos nombres reales de tablas y columnas.
-- ============================================================
-- Tabla principal de empleados: T1_EMPLOYEES
-- Columnas más importantes:
--   employee_id, first_name, last_name, email, phone_number,
--   hire_date, job_id, salary, commission_pct, manager_id, department_id
--
-- Tabla de departamentos: T1_DEPARTMENTS
-- Columnas más importantes:
--   department_id, department_name, manager_id, location_id
--
-- Tabla de historial laboral: T1_JOB_HISTORY
-- Columnas más importantes:
--   employee_id, start_date, end_date, job_id, department_id
--
-- Tabla de auditoría: AUDIT_SALARY_ADJUSTMENTS_T1
-- Columnas:
--   audit_id, execution_tag, variant_id, employee_id, department_id,
--   salary_before, salary_after, pct_gap_to_avg_before, rule_applied,
--   executed_by, executed_at, notes
--
-- Tabla de variantes: T1_VARIANTS
-- Columnas:
--   variant_id, variant_name, excluded_department_id, min_years_service,
--   recent_job_history_months, gap_high_threshold_pct,
--   gap_mid_threshold_pct, raise_high_pct, raise_mid_pct,
--   raise_low_pct, max_salary_vs_avg_pct, notes

-- ============================================================
-- GUÍA RÁPIDA DE TÉRMINOS QUE DEBE USAR EN SU SOLUCIÓN
-- ============================================================
-- CTE:
--   Una CTE es una consulta temporal escrita con WITH.
--   Sirve para dividir una consulta grande en partes más claras.
--
--   Ejemplo:
--   WITH dept_stats AS (
--       SELECT department_id, AVG(salary) avg_salary
--       FROM t1_employees
--       GROUP BY department_id
--   )
--   SELECT *
--   FROM dept_stats;
--
-- Función analítica:
--   Es una función como ROW_NUMBER, RANK o DENSE_RANK.
--   Sirve para calcular posiciones o comparaciones sin perder el detalle.
--
--   Ejemplo:
--   DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC)
--
-- JOIN:
--   Es la unión entre tablas relacionadas, por ejemplo empleados y departamentos.
--
-- Subconsulta:
--   Es una consulta dentro de otra consulta.
--
-- SAVEPOINT:
--   Es un punto de restauración dentro de una transacción.
--   Permite devolver la operación a un punto intermedio con ROLLBACK TO.

-- ============================================================
-- 1. CONSULTA DIAGNÓSTICA
-- OBJETIVO:
-- Analizar la información antes de actualizar salarios.
--
-- SU CONSULTA DEBE MOSTRAR, COMO MÍNIMO, ESTAS COLUMNAS:
--   employee_id
--   first_name
--   last_name
--   job_id
--   manager_id
--   department_id
--   department_name -----
--   salary
--   hire_date
--   years_service ******
--   dept_avg_salary *******
--   dept_max_salary *******
--   dept_employee_count ********
--   pct_gap_to_avg *********
--   recent_job_history_flag *******
--   salary_rank_in_department ******
--
-- QUÉ SIGNIFICA CADA COLUMNA:
--   years_service: años de antigüedad del empleado
--   dept_avg_salary: promedio salarial del departamento
--   dept_max_salary: salario más alto del departamento
--   dept_employee_count: cantidad de empleados del departamento
--   pct_gap_to_avg: porcentaje que le falta al salario del empleado para llegar
--                   al promedio del departamento
--   recent_job_history_flag: SI o NO, según si tuvo historial reciente
--   salary_rank_in_department: posición salarial dentro del departamento
--
-- IMPORTANTE:
-- - Puede usar una o varias CTE
-- - Debe usar al menos una función analítica
-- - Debe unir como mínimo T1_EMPLOYEES con T1_DEPARTMENTS
-- - Debe revisar T1_JOB_HISTORY para detectar historial reciente
-- ============================================================

PROMPT ===== 1. CONSULTA DIAGNÓSTICA =====

-- ESCRIBA AQUÍ SU CONSULTA DIAGNÓSTICA PRINCIPAL
-- Debe devolver las columnas mínimas exigidas arriba.
WITH department AS (
    SELECT 
        department_id, 
        AVG(salary) AS dept_avg_salary, 
        MAX(salary) AS dept_max_salary, 
        COUNT(*) AS dept_employee_count
    FROM T1_EMPLOYEES
    GROUP BY department_id
),
employee AS (
    SELECT e.employee_id, e.first_name, e.last_name, e.job_id, e.manager_id, e.department_id, d.department_name, e.salary, e.hire_date,
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e.hire_date) AS years_service,
        CASE 
            WHEN e.employee_id IN (SELECT h.employee_id FROM T1_JOB_HISTORY h) THEN 'SI' 
            ELSE 'NO' 
        END AS recent_job_history_flag,
        RANK() OVER(PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank_in_department
    FROM T1_EMPLOYEES e
    LEFT JOIN T1_DEPARTMENTS d ON e.department_id = d.department_id
)
SELECT 
    e.employee_id, e.first_name, e.last_name, e.job_id, e.manager_id, e.department_id, e.department_name, e.salary, e.hire_date,
    e.years_service, d.dept_max_salary, d.dept_employee_count, e.recent_job_history_flag, e.salary_rank_in_department,
    CASE 
        WHEN e.salary < d.dept_avg_salary THEN ROUND(((d.dept_avg_salary - e.salary) / d.dept_avg_salary) * 100, 2)
        ELSE 0.00
    END AS pct_gap_to_avg
FROM employee e 
LEFT JOIN department d ON e.department_id = d.department_id;

-- COMENTARIO OBLIGATORIO:
-- Separamos las consultas de empleados y de departamentos en dos CTE, de esta forma, solo hacemos
-- un left join entre ambas, trayendo todas las columnas ya existentes y las que calculamos en los CTE.

-- ============================================================
-- 2. DECISIÓN DE POBLACIÓN ELEGIBLE
-- OBJETIVO:
-- Determinar qué empleados sí califican, cuáles no califican y por qué.
--
-- SU CONSULTA DEBE MOSTRAR, COMO MÍNIMO, ESTAS COLUMNAS:
--   employee_id
--   first_name
--   last_name
--   department_id
--   department_name
--   salary
--   years_service
--   dept_avg_salary
--   dept_max_salary
--   dept_employee_count
--   pct_gap_to_avg
--   recent_job_history_flag
--   manager_or_exec_flag
--   eligibility_flag
--   exclusion_reason
--   adjustment_pct
--   rule_applied
--
-- QUÉ SIGNIFICA CADA COLUMNA:
--   manager_or_exec_flag: SI o NO, según si es gerente principal o alta dirección
--   eligibility_flag: ELEGIBLE o NO_ELEGIBLE
--   exclusion_reason: motivo de exclusión, por ejemplo:
--                     SIN_DEPARTAMENTO, HISTORIAL_RECIENTE,
--                     ANTIGUEDAD_INSUFICIENTE, MANAGER_O_DIRECTIVO,
--                     DEPTO_EXCLUIDO, DEPTO_MENOR_A_3, SALARIO_NO_APLICA
--   adjustment_pct: porcentaje de ajuste que le corresponde
--   rule_applied: regla aplicada, por ejemplo AJUSTE_ALTO, AJUSTE_MEDIO, AJUSTE_BAJO
--
-- IMPORTANTE:
-- - Debe tomar en cuenta la variante asignada por el docente
-- - Debe usar los valores de T1_VARIANTS según &p_variant_id
-- - Debe quedar visible por qué una persona sí o no entra al proceso
-- ============================================================

PROMPT ===== 2. DECISIÓN DE ELEGIBLES =====

-- ESCRIBA AQUÍ SU CONSULTA DE DECISIÓN DE ELEGIBLES
-- Debe devolver las columnas mínimas exigidas arriba.
WITH department AS (
    SELECT 
        department_id, 
        AVG(salary) AS dept_avg_salary,
        MAX(salary) AS dept_max_salary,
        COUNT(*) AS dept_employee_count
    FROM T1_EMPLOYEES
    GROUP BY department_id
),
employee AS (
    SELECT 
        e.employee_id, e.first_name, e.last_name, e.job_id, e.manager_id, e.department_id, d.department_name, e.salary, e.hire_date,
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e.hire_date) AS years_service,
        CASE WHEN e.employee_id IN (SELECT h.employee_id FROM T1_JOB_HISTORY h) THEN 'SI' ELSE 'NO' END AS recent_job_history_flag
    FROM T1_EMPLOYEES e
    LEFT JOIN T1_DEPARTMENTS d ON e.department_id = d.department_id
),
variante AS (
    SELECT 
        emp.*,
        met.dept_avg_salary, met.dept_max_salary, met.dept_employee_count,
        CASE 
            WHEN emp.salary < met.dept_avg_salary THEN ROUND(((met.dept_avg_salary - emp.salary) / met.dept_avg_salary) * 100, 2)
            ELSE 0.00
        END AS pct_gap_to_avg,
        CASE 
            WHEN emp.department_id IS NULL THEN 'SIN_DEPARTAMENTO'
            WHEN emp.department_id = 100 THEN 'DEPTO_EXCLUIDO' -- Excluye Finanzas (100)
            WHEN emp.recent_job_history_flag = 'SI' THEN 'HISTORIAL_RECIENTE'
            WHEN emp.years_service < 4 THEN 'ANTIGUEDAD_INSUFICIENTE' -- Mínimo 4 años
            WHEN emp.job_id IN ('AC_MGR', 'AD_PRES', 'AD_VP') THEN 'MANAGER_O_DIRECTIVO'
            WHEN met.dept_employee_count < 3 THEN 'DEPTO_MENOR_A_3'
            WHEN emp.salary >= met.dept_avg_salary THEN 'SALARIO_NO_APLICA'
            ELSE NULL 
        END AS exclusion_reason_raw
    FROM employee emp
    LEFT JOIN department met ON emp.department_id = met.department_id
)
SELECT 
    employee_id, first_name, last_name, department_id, department_name, salary, years_service,
    ROUND(dept_avg_salary, 2) AS dept_avg_salary, dept_max_salary, dept_employee_count, pct_gap_to_avg,
    recent_job_history_flag,
    CASE WHEN job_id IN ('AC_MGR', 'AD_PRES', 'AD_VP') THEN 'SI' ELSE 'NO' END AS manager_or_exec_flag,
    CASE WHEN exclusion_reason_raw IS NULL THEN 'ELEGIBLE' ELSE 'NO_ELEGIBLE' END AS eligibility_flag,
    COALESCE(exclusion_reason_raw, 'NINGUNA') AS exclusion_reason,
    CASE 
        WHEN exclusion_reason_raw IS NOT NULL THEN 0.00
        WHEN pct_gap_to_avg >= 12 THEN 7.00
        WHEN pct_gap_to_avg >= 6 THEN 4.00
        ELSE 2.00
    END AS adjustment_pct,
    CASE 
        WHEN exclusion_reason_raw IS NOT NULL THEN 'NO_APLICA'
        WHEN pct_gap_to_avg >= 12 THEN 'AJUSTE_ALTO'
        WHEN pct_gap_to_avg >= 6 THEN 'AJUSTE_MEDIO'
        ELSE 'AJUSTE_BAJO'
    END AS rule_applied
FROM variante
ORDER BY department_id, salary DESC;

-- COMENTARIO OBLIGATORIO:
-- Utilizando otro CTE tomamos las condiciones de la variante 3 y elegimos a las personas
-- que calificarían para el aumento.

-- ============================================================
-- 3. PREVALIDACIÓN ANTES DE LA TRANSACCIÓN
-- OBJETIVO:
-- Mostrar qué pasaría antes de ejecutar el cambio real.
--
-- DEBE MOSTRAR, COMO MÍNIMO:
-- A. Un resumen con estas columnas:
--    total_eligible_employees
--    total_salary_before
--    total_salary_after
--    total_increment
--
-- B. Un detalle de empleados elegibles con estas columnas:
--    employee_id
--    department_id
--    salary_before
--    salary_after
--    adjustment_pct
--    rule_applied
--
-- C. Un control de topes por departamento con estas columnas:
--    department_id
--    department_name
--    dept_avg_salary
--    dept_max_salary
--    max_allowed_salary_by_variant
--
-- QUÉ SIGNIFICA:
--   total_salary_before: suma de salarios antes del ajuste
--   total_salary_after: suma de salarios proyectados después del ajuste
--   total_increment: incremento total proyectado
--   max_allowed_salary_by_variant: salario máximo permitido según la variante
-- ============================================================

PROMPT ===== 3. PREVALIDACIÓN =====

-- ESCRIBA AQUÍ SU CONSULTA O SUS CONSULTAS DE PREVALIDACIÓN
-- Debe mostrar el resumen, el detalle y el control de topes.
WITH department AS (
    SELECT 
        department_id, 
        AVG(salary) AS dept_avg_salary,
        MAX(salary) AS dept_max_salary,
        COUNT(*) AS dept_employee_count
    FROM T1_EMPLOYEES
    GROUP BY department_id
),
employee AS (
    SELECT 
        e.employee_id, e.first_name, e.last_name, e.job_id, e.manager_id, e.department_id, d.department_name, e.salary, e.hire_date,
        EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM e.hire_date) AS years_service,
        CASE WHEN e.employee_id IN (SELECT h.employee_id FROM T1_JOB_HISTORY h) THEN 'SI' ELSE 'NO' END AS recent_job_history_flag
    FROM T1_EMPLOYEES e
    LEFT JOIN T1_DEPARTMENTS d ON e.department_id = d.department_id
),
variante AS (
    SELECT 
        emp.*,
        met.dept_avg_salary, met.dept_max_salary, met.dept_employee_count,
        CASE 
            WHEN emp.salary < met.dept_avg_salary THEN ROUND(((met.dept_avg_salary - emp.salary) / met.dept_avg_salary) * 100, 2)
            ELSE 0.00
        END AS pct_gap_to_avg,
        CASE 
            WHEN emp.department_id IS NULL THEN 'SIN_DEPARTAMENTO'
            WHEN emp.department_id = 100 THEN 'DEPTO_EXCLUIDO' -- Excluye Finanzas (100)
            WHEN emp.recent_job_history_flag = 'SI' THEN 'HISTORIAL_RECIENTE'
            WHEN emp.years_service < 4 THEN 'ANTIGUEDAD_INSUFICIENTE' -- Mínimo 4 años
            WHEN emp.job_id IN ('AC_MGR', 'AD_PRES', 'AD_VP') THEN 'MANAGER_O_DIRECTIVO'
            WHEN met.dept_employee_count < 3 THEN 'DEPTO_MENOR_A_3'
            WHEN emp.salary >= met.dept_avg_salary THEN 'SALARIO_NO_APLICA'
            ELSE NULL 
        END AS exclusion_reason_raw
    FROM employee emp
    LEFT JOIN department met ON emp.department_id = met.department_id
)
SELECT 
    employee_id, first_name, last_name, department_id, department_name, salary, years_service,
    ROUND(dept_avg_salary, 2) AS dept_avg_salary, dept_max_salary, dept_employee_count, pct_gap_to_avg,
    recent_job_history_flag,
    CASE WHEN job_id IN ('AC_MGR', 'AD_PRES', 'AD_VP') THEN 'SI' ELSE 'NO' END AS manager_or_exec_flag,
    CASE WHEN exclusion_reason_raw IS NULL THEN 'ELEGIBLE' ELSE 'NO_ELEGIBLE' END AS eligibility_flag,
    COALESCE(exclusion_reason_raw, 'NINGUNA') AS exclusion_reason,
    CASE 
        WHEN exclusion_reason_raw IS NOT NULL THEN 0.00
        WHEN pct_gap_to_avg >= 12 THEN 7.00
        WHEN pct_gap_to_avg >= 6 THEN 4.00
        ELSE 2.00
    END AS adjustment_pct,
    CASE 
        WHEN exclusion_reason_raw IS NOT NULL THEN 'NO_APLICA'
        WHEN pct_gap_to_avg >= 12 THEN 'AJUSTE_ALTO'
        WHEN pct_gap_to_avg >= 6 THEN 'AJUSTE_MEDIO'
        ELSE 'AJUSTE_BAJO'
    END AS rule_applied
FROM variante
ORDER BY department_id, salary DESC;

-- ============================================================
-- 4. EJECUCIÓN TRANSACCIONAL
-- OBJETIVO:
-- Ejecutar la actualización real y registrar la auditoría.
--
-- DEBE INCLUIR OBLIGATORIAMENTE:
-- 1. SAVEPOINT
-- 2. UPDATE o MERGE para actualizar salarios
-- 3. INSERT a AUDIT_SALARY_ADJUSTMENTS_T1
-- 4. Validación intermedia
-- 5. COMMIT o ROLLBACK TO SAVEPOINT
--
-- IMPORTANTE:
-- - La auditoría debe usar el valor &p_execution_tag
-- - La auditoría debe usar el valor &p_variant_id
-- - Debe usar la secuencia AUDIT_SALARY_ADJ_T1_SEQ.NEXTVAL
-- ============================================================

PROMPT ===== 4. EJECUCIÓN TRANSACCIONAL =====

SAVEPOINT sv_before_adjustment;

-- 4.1 ACTUALIZACIÓN DE SALARIOS
-- ESCRIBA AQUÍ SU UPDATE O MERGE
-- Debe actualizar únicamente empleados ELEGIBLES.



-- 4.2 INSERCIÓN EN AUDITORÍA
-- Debe llenar estas columnas de AUDIT_SALARY_ADJUSTMENTS_T1:
--   audit_id               -> usar AUDIT_SALARY_ADJ_T1_SEQ.NEXTVAL
--   execution_tag          -> usar &p_execution_tag
--   variant_id             -> usar &p_variant_id
--   employee_id            -> id del empleado ajustado
--   department_id          -> departamento del empleado
--   salary_before          -> salario antes del ajuste
--   salary_after           -> salario después del ajuste
--   pct_gap_to_avg_before  -> brecha porcentual antes del ajuste
--   rule_applied           -> regla aplicada
--   executed_by            -> USER
--   executed_at            -> SYSDATE
--   notes                  -> comentario libre

INSERT INTO audit_salary_adjustments_t1 (
    audit_id,
    execution_tag,
    variant_id,
    employee_id,
    department_id,
    salary_before,
    salary_after,
    pct_gap_to_avg_before,
    rule_applied,
    executed_by,
    executed_at,
    notes
)
-- ESCRIBA AQUÍ SU SELECT O VALUES PARA INSERTAR LA AUDITORÍA
;

-- 4.3 VALIDACIÓN INTERMEDIA
-- Debe mostrar, como mínimo, estas columnas:
--   employee_id
--   department_id
--   current_salary
--   original_salary
--   allowed_max_salary
--   validation_status
--
-- validation_status debe indicar si cumple o no cumple.

PROMPT ===== 4.3 VALIDACIÓN INTERMEDIA =====

-- ESCRIBA AQUÍ SU CONSULTA DE VALIDACIÓN INTERMEDIA



-- 4.4 CONTROL TRANSACCIONAL
-- Debe demostrar UNO de estos escenarios:
-- A. COMMIT si toda la validación es correcta
-- B. ROLLBACK TO SAVEPOINT si detecta incumplimientos
--
-- ESCRIBA AQUÍ SU DECISIÓN TRANSACCIONAL Y AGREGUE UN COMENTARIO
-- explicando por qué hizo COMMIT o por qué hizo ROLLBACK.



-- ============================================================
-- 5. VALIDACIÓN POSTERIOR
-- OBJETIVO:
-- Demostrar el resultado final de la transacción.
--
-- DEBE MOSTRAR, COMO MÍNIMO, ESTAS 4 SALIDAS:
--
-- SALIDA 1. Empleados impactados
-- Columnas mínimas:
--   employee_id, first_name, last_name, department_id,
--   salary_before, salary_after, execution_tag
--
-- SALIDA 2. Resumen económico final
-- Columnas mínimas:
--   total_rows_audited, total_salary_before, total_salary_after, total_increment
--
-- SALIDA 3. Validación de topes
-- Columnas mínimas:
--   employee_id, department_id, salary_after, allowed_max_salary, top_limit_status
--
-- SALIDA 4. Auditoría generada
-- Columnas mínimas:
--   audit_id, execution_tag, variant_id, employee_id, department_id,
--   salary_before, salary_after, rule_applied, executed_by, executed_at
--
-- IMPORTANTE:
-- Todas las validaciones posteriores deben filtrar por &p_execution_tag
-- ============================================================

PROMPT ===== 5. VALIDACIÓN POSTERIOR =====

-- SALIDA 1. EMPLEADOS IMPACTADOS



-- SALIDA 2. RESUMEN ECONÓMICO FINAL



-- SALIDA 3. VALIDACIÓN DE TOPES



-- SALIDA 4. AUDITORÍA GENERADA



-- ============================================================
-- 6. JUSTIFICACIÓN TÉCNICA
-- Responder dentro del script, en comentarios.
-- Cada respuesta debe tener entre 3 y 6 líneas.
-- ============================================================

-- ATOMICIDAD:
-- Explique cómo su solución demuestra atomicidad.
--
-- RESPUESTA:

-- CONSISTENCIA:
-- Explique cómo su solución asegura que los datos quedan válidos
-- después de la operación.
--
-- RESPUESTA:

-- AISLAMIENTO:
-- Explique cómo se comportaría su transacción frente a otras sesiones.
--
-- RESPUESTA: 

-- DURABILIDAD:
-- Explique qué garantiza la persistencia del cambio una vez confirmado.
--
-- RESPUESTA:

-- USO DE SAVEPOINT / ROLLBACK:
-- Explique qué riesgo controló y por qué ese punto de restauración
-- era necesario.
--
-- RESPUESTA:

PROMPT ===== Fin de plantilla =====
