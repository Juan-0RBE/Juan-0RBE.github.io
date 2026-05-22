---
title: 'SQL'
description: 'Trabajos relacionados con SQL'
publishDate: '2026-02-14'
---

- [Ejercicios Iniciales Álgebra Relacional](#ejercicios-iniciales-de-álgebra-relacional)
- [Ejercicios Iniciales SQL](#ejercicios-iniciales)
- [Laboratorio SQL](#laboratorio-sql)

## Ejercicios iniciales de álgebra relacional

Antes de pasar a realizar ejercicios con sentencias SQL, se estudió álgebra relacional. Es el lenguaje teórico detrás de SQL. Todo lo que se realiza con SELECT, WHERE, JOIN en SQL tiene su equivalente en álgebra relacional. El proceso de aprender álgebra relacional es como aprender las matemáticas detrás de SQL, esto permite una comprensión más profunda a la hora de pasar a realizar sentencias en SQL. A continuación, se presenta un documento con ejercicios de
álgebra relacional.

**Tercer taller Grupal:** En este taller se realizaron diferentes expresiones de álgebra relacional, a partir de algunas tablas dadas.

-> [Ver archivo PDF con la solución](/pdf/TercerTaller_GarciaJavier_OrjuelaJuan.pdf)

## Ejercicios en clase

**Primera clase:** En esta clase se crearon los SCRIPT para poder crear todas las tablas para trabajar en los diferentes ejercicios. Las tablas corresponden al esquema HR (Human Resources / Recursos Humanos) de Oracle Database. Contiene tablas como:

- EMPLOYEES – datos de empleados (salario, job, manager, etc.)
- DEPARTMENTS – departamentos de la empresa
- JOBS – tipos de cargo con rangos salariales
- LOCATIONS – ubicaciones físicas
- COUNTRIES y REGIONS – datos geográficos
- JOB_HISTORY – historial de cargos de empleados

-> [Descargar Archivo SQL](/sql/Clase_Creacion_Tablas.sql)

**Segunda Clase:** En esta clase se trabajaron las primeras sentecias DQL de SQL, como lo son SELECT, FROM y WHERE.

-> [Descargar Archivo SQL](/sql/Clase_Sentencias.sql)

**Tercera Clase:** En esta clase se trabajaron las todas las sentencias join, como lo son LEFT JOIN, INNER JOIN, FULL OUTER JOIN, entre otros. También
se encuentra un archivo sql con ejercicios de práctica de JOIN.

-> [Descargar Archivo SQL](/sql/Join.sql)

-> [Descargar Archivo de repaso SQL](/sql/Ejercicios_Join.sql)

## Laboratorio SQL

El presente taller tiene como objetivo aplicar conceptos de SQL avanzado y manejo de transacciones en bases de datos utilizando como referencia el esquema HR de Oracle Database. A partir de este entorno, se trabajan tablas adicionales relacionadas con empleados, departamentos e historial laboral, con el fin de desarrollar un proceso de ajuste salarial dentro de una empresa.

Durante la actividad se implementan diferentes consultas y operaciones avanzadas, haciendo uso de herramientas como CTEs, funciones analíticas, subconsultas y sentencias JOIN, permitiendo analizar la información de los empleados y calcular ajustes salariales bajo determinadas reglas de negocio. Además, se emplean transacciones ACID para garantizar la integridad y consistencia de los datos mediante operaciones como COMMIT, ROLLBACK y SAVEPOINT.

- Configuración del taller:

-> [Descargar archivo SQL con configuración de tablas](/sql/01_setup_taller1.sql)

-> [Descargar archivo SQL con los datos de las tablas](/sql/02_datos_taller1.sql)

-> [Descargar archivo SQL con la plantilla de la solución](/sql/03_template_entrega_taller1_v2.sql)

- Solución del taller:

-> [Descargar archivo SQL con los procedimientos realizados](/sql/Taller1_Avanzado.sql)

-> [Ver archivo PDF con los procedimientos realizados ](/pdf/Taller_avanzado_1_GarciaJavier_OrjuelaJuan.pdf)
