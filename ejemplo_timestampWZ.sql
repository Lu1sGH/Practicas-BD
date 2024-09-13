set pagesize 99
set linesize 250
set null s/Datos
set colsep '|| '

drop   table t_fech_ts_wz;
create table t_fech_ts_wz(
	fecha_ts_w_tz       TIMESTAMP WITH TIME ZONE,
	fech_tswz_en_format_j VARCHAR2 (14)
	);
REM PRIMERA FECHA 

insert into t_fech_ts_wz	
VALUES (TO_TIMESTAMP_TZ('01-ENE-2024 07:25:32.000001000 +1:00', 
		                'DD-MON-sYYYY HH24:MI:SS.FF9 TZH:TZM'),null);
REM SEGUNDA FECHA 
insert into t_fech_ts_wz	
VALUES (TO_TIMESTAMP_TZ('01-MAR--0753 07:25:32.000256000 +5:00', 
		                'DD-MON-sYYYY HH24:MI:SS.FF9 TZH:TZM'),null);
REM TERCERA FECHA 
insert into t_fech_ts_wz	
VALUES (TO_TIMESTAMP_TZ('01-JUN-2000 07:25:32.000512000 +8:00', 
		                'DD-MON-sYYYY HH24:MI:SS.FF9 TZH:TZM'),null);

REM CUARTA  FECHA 
insert into t_fech_ts_wz	
VALUES (TO_TIMESTAMP_TZ('01-JUL-2022 07:25:32.001024000 -4:00', 
		                'DD-MON-sYYYY HH24:MI:SS.FF9 TZH:TZM'),null);
REM QUINTA FECHA 
insert into t_fech_ts_wz	
VALUES (TO_TIMESTAMP_TZ('01-SEP-2004 07:25:32.002048000 -7:00', 
		                'DD-MON-sYYYY HH24:MI:SS.FF9 TZH:TZM'),null);

select * from t_fech_ts_wz;

						
col   fecha_WTZ  format a40
COL   NUM_NATUR  FORMAT 999,999,999			
select   fecha_ts_w_tz fecha_WTZ ,  fech_tswz_en_format_j NUM_NATUR from t_fech_ts_wz;	

REM DESPLEGUEMOS LOS MESES CON LETRAS 
col   fecha_WTZ  format a47
select  TO_CHAR( fecha_ts_w_tz,'DD-MONTH-sYYYY HH24:MI:SS.FF9 TZH:TZM')  fecha_WTZ , 
         fech_tswz_en_format_j                                         NUM_NATUR 
		 from t_fech_ts_wz;
		 
REM DEPLEGUEMOS EL ATRIBUTO TZW COMO SE ALMACENA EN LA TABLA 

COL MEMORIA     FORMAT A53
select  TO_CHAR( fecha_ts_w_tz,'DD-MONTH-sYYYY HH24:MI:SS.FF9 TZH:TZM')  fecha_WTZ , 
         DUMP  ( fecha_ts_w_tz ) MEMORIA 
		 from t_fech_ts_wz;
		 
		 
UPDATE t_fech_ts_wz SET fech_tswz_en_format_j = TO_CHAR( fecha_ts_w_tz,'J');

REM DESPLEGUEMOS EL VARCHAR2 COMO NUMERO
 
select  TO_CHAR( fecha_ts_w_tz,'DD-MONTH-sYYYY HH24:MI:SS.FF9 TZH:TZM')  fecha_WTZ , 
         TO_NUMBER(fech_tswz_en_format_j,'999999999')                NUM_NATUR 
		 from t_fech_ts_wz;
		 
