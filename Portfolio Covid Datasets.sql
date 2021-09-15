Use PortfolioProject

--Select Data that we are going to be using

Select Location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by location,date

--Looking at  Total Deaths Vs Total Cases
--Shows likelihood of dying if you contract covid in your country

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%India%'
order by DeathPercentage desc

--Looking at total Cases Vs Population
--Shows what Percentage of Population got Covid

Select Location,date,total_cases,population,(total_cases/population)*100 as PercentagePopulationInfected
from CovidDeaths
where location like '%India%'
order by PercentagePopulationInfected desc



--Looking Countries wuth Highest Infection Rate Compared to Population
Select Location,population,max(total_cases) As InfectionCount,Max((total_cases/population))*100 as PercentagePopulationInfected
from CovidDeaths
--where location like '%India%'
group by location, population
order by PercentagePopulationInfected desc

--Showing Countries with Highest Death Count per Population

Select Location,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%India%'
where continent is not null
group by location
order by TotalDeathCount desc

--Lets Break things Down by Continent

--Showing Contintents with the Highest Death count per Population

Select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%India%'
where continent is not null
group by continent
order by TotalDeathCount desc

--Global Numbers

Select sum(new_cases) As TotalCases,sum(cast(new_deaths as int)) As TotalDeaths,sum(cast(new_deaths as int))/sum(new_cases)*100 As DeathPercentage      
from CovidDeaths
where continent is not null
--Group by date
order by 1,2


---Looking at Population vs Vaccinations

select De.continent,De.location,De.date,De.population,cast(Va.new_vaccinations as int) as new_vaccinations,
SUM(convert(int,Va.new_vaccinations)) OVER (PARTITION by de.location Order by De.location, de.date) As [Rolling people Vaccinated]
from CovidDeaths De join CovidVaccinations Va on De.location = Va.location
and De.date = Va.date
where De.continent is not null
--where De.location like '%India%'
order by 2,3


--Looking at Your Country Vs Vaccinations

select De.continent,De.location,De.date,De.population,cast(Va.new_vaccinations as int) As new_vaccinations from CovidDeaths De join CovidVaccinations Va on De.location = Va.location
and De.date = Va.date
--where De.continent is not null
where De.location like '%India%'
order by 5 desc

--Use CTE

with PopVsVac (continent,Location, Date, Population,new_vaccinations,[Rolling people Vaccinated])
as
(select De.continent,De.location,De.date,De.population,cast(Va.new_vaccinations as int) as new_vaccinations,
SUM(convert(int,Va.new_vaccinations)) OVER (PARTITION by de.location Order by De.location, de.date) As [Rolling people Vaccinated]
from CovidDeaths De join CovidVaccinations Va on De.location = Va.location
and De.date = Va.date
where De.continent is not null
--where De.location like '%India%'
--order by 2,3
)

Select *,([Rolling people Vaccinated]/Population)*100 As [Rolling Vaccination Percentage]from  PopVsVac




--TEMP TABLE

DROP TABLE if Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(300),
Location nvarchar(300),
Date datetime,
Population numeric,
new_vaccinations numeric,
[Rolling People Vaccinated] numeric)

insert into #PercentPopulationVaccinated

select De.continent,De.location,De.date,De.population,cast(Va.new_vaccinations as int) as new_vaccinations,
SUM(convert(int,Va.new_vaccinations)) OVER (PARTITION by de.location Order by De.location, de.date) As [Rolling people Vaccinated]
from CovidDeaths De join CovidVaccinations Va on De.location = Va.location
and De.date = Va.date
where De.continent is not null
--where De.location like '%India%'
--order by 2,3

Select *,([Rolling people Vaccinated]/Population)*100 As [Rolling Vaccination Percentage]from  #PercentPopulationVaccinated


--Creating View to Store Data for later Vizualizations

Create view PercentPopulationVaccinated As

select De.continent,De.location,De.date,De.population,cast(Va.new_vaccinations as int) as new_vaccinations,
SUM(convert(int,Va.new_vaccinations)) OVER (PARTITION by de.location Order by De.location, de.date) As [Rolling people Vaccinated]
from CovidDeaths De join CovidVaccinations Va on De.location = Va.location
and De.date = Va.date
where De.continent is not null
--where De.location like '%India%'
--order by 2,3

Select *from PercentPopulationVaccinated








