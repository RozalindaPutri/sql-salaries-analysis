SELECT * FROM `porto1roza.salaries.gaji_karyawan`;

-- 1. Apakah ada data yang null?
SELECT * FROM `porto1roza.salaries.gaji_karyawan`
WHERE work_year is null 
or experience_level is null
or employment_type is null
or job_title is null
or salary is null
or salary_currency is null
or salary_in_usd is null
or employee_residence is null
or remote_ratio is null
or company_location is null
or company_size is null;

-- 2. Ada job title apa saja?
select 
distinct job_title
from `porto1roza.salaries.gaji_karyawan`
order by 1;

-- 3. job title apa saja yg berkaitan dengan data analyst?
select 
distinct job_title
from `porto1roza.salaries.gaji_karyawan`
where job_title like '%Data Analyst%'
order by job_title;

-- 4. Berapa rata rata gaji data analyst dalam sebulan(rupiah)?
select 
round((avg(salary_in_usd) * 15000) / 12,2) as rata_rata_gaji_perbulan
from `porto1roza.salaries.gaji_karyawan`;

-- 4.1 Berapa rata rata gaji data analyst dalam sebulan(rupiah) 
--berdasarkan experience levelnya dan employment typenya?
select 
experience_level,
employment_type,
round((avg(salary_in_usd) * 15000) / 12,2) as rata_rata_gaji_perbulan
from `porto1roza.salaries.gaji_karyawan`
group by experience_level, employment_type
order by experience_level, employment_type;


-- 5. Negara dengan gaji perbulan  posisi data analyst yang  menarik lebih dari 50 juta,
-- full time, experience kerjanya entry level atau menengah 
select company_location,
round((avg(salary_in_usd) * 15000)/12,2) as rata_rata_gaji_perbulan
from `porto1roza.salaries.gaji_karyawan`
where job_title like '%Data Analyst%'
and employment_type = 'FT'
and experience_level  in ('EN', 'MI')
group by 1
HAVING rata_rata_gaji_perbulan >= 50000000
order by 2 desc;

-- 6. Di tahun berapa, kenaikan gaji dari mid ke expert memiliki kenaikan yg tertinggi 
--untuk pekerjaan yang berkaitan dengan data analyst yang penuh waktu
with ds_1 as (
      select 
        work_year, round(avg(salary_in_usd),2) as gaji_ex
        from `porto1roza.salaries.gaji_karyawan`
        where employment_type = 'FT'
        and experience_level = 'EX'
        and job_title like '%Data Analyst%'
        group by work_year),
      ds_2 as(
        select 
        work_year, round(avg(salary_in_usd),2) as gaji_mi
        from `porto1roza.salaries.gaji_karyawan`
        where employment_type = 'FT'
        and experience_level = 'MI'
        and job_title like '%Data Analyst%'
        group by work_year)
        
select 
ds_1.work_year,
ds_1.gaji_ex,
ds_2.gaji_mi,
round((ds_1.gaji_ex - ds_2.gaji_mi),2) as difference
from ds_1 left outer join ds_2 
on ds_1.work_year = ds_2.work_year
order by difference desc;















