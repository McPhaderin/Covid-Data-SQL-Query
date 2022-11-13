select *
from PortfolioProject..CovidDeath

order by 3,4

select *
from PortfolioProject..CovidVaccinations

--Extract the data to be analysed

select location,date,total_cases,new_cases,total_deaths,population

from PortfolioProject..CovidDeath

order by 1, 2

---Total cases Vs Total deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent is not null

order by 1, 2

-- BY CONTINENT EUROPE

select location,continent, date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent = 'Europe'

order by 1, 2,3


-- BY CONTINENT AFRICA

select location,continent, date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent = 'Africa'

order by 1, 2,3

-- BY CONTINENT ASIA

select location,continent, date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent = 'Asia'

order by 1, 2,3


-- BY CONTINENT NORTH AMERICA

select location,continent, date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent = 'North America'

order by 1, 2,3

-- BY CONTINENT SOUTH AMERICA

select location,continent, date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent = 'South America'

order by 1, 2,3


-- BY CONTINENT OCEANIA

select location,continent, date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercentage

from PortfolioProject..CovidDeath

where continent = 'Oceania'

order by 1, 2,3

select DISTINCT location
from PortfolioProject..CovidDeath
where continent = 'Oceania'



---Percenatage of Population with Covid

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

order by 1, 2

---Percenatage of Population with Covid by Continent

--ASIA

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

where continent = 'Asia'

order by 1, 2

--Africa

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

where continent = 'Africa'

order by 1, 2

--Oceania

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

where continent = 'Oceania'

order by 1, 2

--North America

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

where continent = 'North America'

order by 1, 2

--South America

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

where continent = 'South America'

order by 1, 2

--Europe

select location,date,continent,total_cases,population,(total_cases/population) *100 as PercentPopulationInfected

from PortfolioProject..CovidDeath

where continent = 'Europe'

order by 1, 2


--Countries with highest Infection rate

select location , Max(total_cases) as MaxTotalCases, Max(total_cases/population) *100 as MaxPercentPopulation

from PortfolioProject..CovidDeath

Group by location 

order by MaxPercentPopulation desc

--Continent with highest Infection rate

select continent,Max(total_cases) as MaxTotalCases, Max(total_cases/population) *100 as MaxPercentPopulation

from PortfolioProject..CovidDeath

where continent is not null

Group by continent

order by MaxPercentPopulation desc


--Countries with the highest Death Per Population

select location , population,Max(cast(total_deaths as int)) as MaxTotalDeath, (Max(cast(total_deaths as int))/population) *100 as MaxDeathPercent

from PortfolioProject..CovidDeath

Group by location, population

order by MaxDeathPercent desc

--Countries with the highest Death Count

select location ,Max(cast(total_deaths as int)) as MaxTotalDeath

from PortfolioProject..CovidDeath

where continent is not  null

Group by location

order by MaxTotalDeath desc

--Continent with the highest Death Count

select continent ,Max(cast(total_deaths as int)) as MaxTotalDeath

from PortfolioProject..CovidDeath

where continent is not null

Group by continent

order by MaxTotalDeath desc


-- Global Death and Cases

select date ,sum(new_cases) as DailyNewCases, sum(cast(new_deaths as int)) as DailyDeath

from PortfolioProject..CovidDeath

where continent is not null

Group by Date

order by 1, 2

---Global Death Percentage Per day

select date ,sum(new_cases) as DailyNewCases, sum(cast(new_deaths as int)) as DailyDeath, sum(cast(new_deaths as int))/sum(new_cases) *100 as 
DeathPercentage

from PortfolioProject..CovidDeath

where continent is not null

Group by Date

order by 1, 2


---Global Death Percentage

select sum(new_cases) as TotalCases, sum(cast(new_deaths as int)) as Totaldeath, sum(cast(new_deaths as int))/sum(new_cases) *100 as 
DeathPercentage

from PortfolioProject..CovidDeath

where continent is not null

order by 1, 2

--Population Vs Vaccination

select dea.continent,dea.location,dea.date, population, vac.new_vaccinations
,sum(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as CumulativeVaccinated
--(CumulativeVaccinated/population) *100
from PortfolioProject..CovidDeath dea
 join
 PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  order by 2,3

with  PopulationVsVaccination(continent,location,date,population,new_vaccinations, CumulativeVaccinated )
as
(
select dea.continent,dea.location,dea.date, population, vac.new_vaccinations
,sum(CONVERT(bigint,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
dea.date) as CumulativeVaccinated
from PortfolioProject..CovidDeath dea
 join
 PortfolioProject..CovidVaccinations vac
  on dea.location = vac.location
  and dea.date = vac.date
  where dea.continent is not null
  )
  select *,(CumulativeVaccinated/population) *100
  from PopulationVsVaccination


  --CREATING VIEW FOR VISUALIZATION
  
---Total cases Vs Total deaths
 
create view DailyDeathPercentage as
 select location,date,total_cases,total_deaths, (total_deaths/total_cases) *100 as DeathPercent

from PortfolioProject..CovidDeath



