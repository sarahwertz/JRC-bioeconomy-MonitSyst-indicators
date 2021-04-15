import eurostat
import numpy as np
import pandas as pd
import json

# 15 European countries are Belgium, Estonia, Finland, France, Germany, Ireland, Lithuania, Luxembourg, the Netherlands, Portugal, Romania, Slovenia, Spain, Sweden and the United Kingdom.
geo_categories = ['15 European countries', 'EU27', 'EU28', 'Austria', 'Belgium', 'Bulgaria', 'Croatia', 'Cyprus', 'Czechia', 'Denmark', 'Estonia', 'Finland', 'France', 'Germany', 'Greece', 'Hungary', 'Ireland', 'Italy', 'Latvia', 'Lithuania', 'Luxembourg', 'Malta', 'Netherlands', 'Poland', 'Portugal', 'Romania', 'Slovakia', 'Slovenia', 'Spain', 'Sweden', 'United Kingdom']

geo_category_codes_list = ['EU_V', 'EU27_2020', 'EU28', 'AT', 'BE', 'BG', 'HR', 'CY', 'CZ', 'DK', 'EE', 'FI', 'FR', 'DE', 'EL', 'HU', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PL', 'PT', 'RO', 'SK', 'SI', 'ES', 'SE', 'UK']

geo_category_codes_dict = {
    # added for 2.1.d.1
    '15 European countries': 'EU_V',
    'EU27': 'EU27_2020',
    # added for 2.3.a.2
    'EU27_2020': 'EU27_2020',
    # added for 3.4.a.4
    'EU-27': 'EU27_2020',
    # added for 5.1.a.2, 5.1.a.5, 5.1.b.1, 5.1.b.2 and 5.2.a.1
    'European Union (27 countries, from 01/02/2020) ': 'EU27_2020',
    'EU28': 'EU28',
    # added for 2.2.a.1 and 3.4.a.4
    'EU-28': 'EU28',
    # added for 3.4.a.2
    'European Union (27 countries) + UK': 'EU28',
    # added for 3.4.a.3, 5.1.a.2, 5.1.a.5, 5.1.b.1, 5.1.b.2 and 5.2.a.1
    'European Union (28 countries)': 'EU28',
    'Austria': 'AT',
    'Belgium': 'BE',
    'Bulgaria': 'BG',
    'Croatia': 'HR',
    'Cyprus': 'CY',
    'Czechia': 'CZ',
    'Denmark': 'DK',
    'Estonia': 'EE',
    'Finland': 'FI',
    'France': 'FR',
    # added for 1.1.b.1
    'Germany (until 1990 former territory of the FRG)': 'DE',
    'Germany': 'DE',
    'Greece': 'EL',
    'Hungary': 'HU',
    'Ireland': 'IE',
    'Italy': 'IT',
    'Latvia': 'LV',
    'Lithuania': 'LT',
    'Luxembourg': 'LU',
    'Malta': 'MT',
    'Netherlands': 'NL',
    'Poland': 'PL',
    'Portugal': 'PT',
    'Romania': 'RO',
    'Slovakia': 'SK',
    'Slovenia': 'SI',
    'Spain': 'ES',
    'Sweden': 'SE',
    'United Kingdom': 'UK'
}

fishing_areas = ['NE Atlantic', 'Mediterranean & Black Sea']

fishing_area_codes_list = ['27', '37']

fishing_area_codes_dict = {
    'NE Atlantic': '27',
    'Mediterranean & Black Sea': '37'
}

# 'share' denotes percent and 'total' denotes not percent, which come before the type codes in the file names
types = {
    # biomass-uses
    'total_biomass_supply_for_materials': 'total biomass supply for materials',
    'total_biomass_supply_for_energy': 'total biomass supply for energy',
    'total_biomass_supply_for_food_purposes,_including_inputs': 'total biomass supply for food purposes, including inputs',
    # 1.1.a.1
    'I10': 'index',
    # 1.1.a.4, 3.4.a.2 and 3.4.a.3
    '1000_T_of_dry_matter_(Net_trade)': '1000 t of dry matter (net trade)',
    # 1.1.b.1 (hard coded)
    'percent': 'percent',
    # 1.1.c.1
    'ANI': 'animal',
    'VEG': 'vegetal',
    'TOTAL': 'total',
    # 2.1.b.4
    'PC_UAA': 'share of organic farming in utilised agricultural area',
    # 2.1.b.9
    'GS_FOR': 'growing stock of forests',
    'GS_OWL': 'growing stock of other wooded land',
    # 2.1.d.1
    'CO_FARM_I90': 'common farmland birds (index, 1990=100)',
    'CO_FARM_I00': 'common farmland birds (index, 2000=100)',
    'CO_FOR_I90': 'common forest birds (index, 1990=100)',
    'CO_FOR_I00': 'common forest birds (index, 2000=100)',
    'SME_I90': 'grassland butterflies (index, 1990=100)',
    'SME_I00': 'grassland butterflies (index, 2000=100)',
    # 2.1.e.1
    # TPA_PC and TPA_KM2 will be differentiated when the units will be added
    'TPA_PC': 'surface of terrestrial protected sites',
    'TPA_KM2': 'surface of terrestrial protected sites',
    'MPA_KM2': 'surface of marine protected sites',
    # 2.2.a.1 (hard coded)
    'felling_rates': 'felling rates',
    # 2.2.b.2 (hard coded)
    'exploitation': 'exploitation levels',
    # 2.2.d.5
    'LOW_INP': 'low-input farms',
    'MED_INP': 'medium-input farms',
    'HIGH_INP': 'high-input farms',
    # 2.3.a.2
    'm3_solid_volume_o.b.': 'roundwood removals',
    # 3.1.a.1
    'MF1': 'biomass',
    # 3.1.a.2
    'Material_Footprint_(Biomass)_per_capita': 'material footprint (biomass) per capita',
    # 3.1.b.1
    'EUR_KGOE': 'energy productivity',
    # 3.1.b.2
    'T2020_31': 'share of renewables',
    # 3.1.c.2 and 4.1.b.3
    'PC': 'percent',
    # 3.4.a.4
    'ene': 'energy',
    'mat': 'materials',
    # 4.1.a.3
    'CRF3': 'agriculture',
    # 4.1.a.6
    'CRF4': 'LULUCF',
    # 5.1.a.2, 5.1.a.5, 5.1.b.1, 5.1.b.2 and 5.2.a.1
    'A01': 'agriculture',
    'A02': 'forestry',
    'A03': 'fishing and aquaculture',
    'bC13': 'bio-based textile',
    'bC14': 'bio-based wearing apparel',
    'bC15': 'leather',
    'bC16': 'wood products',
    'bC17': 'paper',
    'bC21': 'bio-based pharmaceuticals',
    'bC22': 'rubber and bio-based plastics',
    'bC31': 'wooden furniture',
    'bchem': 'bio-based chemicals (excluding biofuels)',
    'bD3511': 'bio-based electricity',
    'Biod': 'biodiesel',
    'Bioeth': 'bioethanol',
    'C10': 'food',
    'C11': 'beverage',
    'C12': 'tobacco'
 }

def getGeoCategoryCode(geo_category):
    return geo_category_codes_dict[geo_category]

def getFishingAreaCode(fishing_area):
    return fishing_area_codes_dict[fishing_area]

def getType(type_code):
    return types[type_code]



### HEADLINE INDICATORS ###

def makeJsonArea(years):
    df = pd.read_excel('../input_data/biomass-uses-1.1.a.4.xlsx', sheet_name='forsplashpage')

    data = []

    for i in df.index:
        for year in years:
            if df['geography'][i] != 'EU27':
              data.append([df['geography'][i], year, df[year][i], df['indicator'][i].lower().replace(' ', '_')])

    df_reorganized = pd.DataFrame(data, columns = ['geo_code', 'time', 'value', 'type'])
    df_reorganized.to_csv('../output_data/headline_indicators/biomass_uses/biomass-uses.csv', index = False)

    type_codes = ['total_biomass_supply_for_materials', 'total_biomass_supply_for_energy', 'total_biomass_supply_for_food_purposes,_including_inputs']

    data = {}
    data['unit'] = df['unit'][0].lower()
    data['categories'] = years
    data['series'] = []
    for type_code in type_codes:
        series_data = {}
        series_data['name'] = getType(type_code)
        series_data['data'] = []
        for year in years:
            series_data['data'].append(df_reorganized.query('geo_code == "EU28" & time == @year & type == @type_code')['value'].tolist()[0])
        data['series'].append(series_data)

    with open('../output_data/headline_indicators/biomass_uses/biomass-uses.json', 'w', encoding = 'utf-8') as f:
        json.dump(data, f, ensure_ascii = False, indent = 4)



def makeJsonPieEmploymentValueAdded(year):
    df = pd.read_csv('../input_data/5.1.a.2-5.1.b.1-5.1.b.2-5.2.a.1.csv')

    df = df[df['Country (Code)'] == 'EU27'].query('Year == @year')

    df = df[df['Sector (NACE rev. 2) (Code)'] == 'A01'].append(df[df['Sector (NACE rev. 2) (Code)'] == 'A02']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'A03']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bC16']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bC17']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bC31']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bCHEM']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bD3511']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bFUEL']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'bTEXT']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'C10']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'C11']).append(df[df['Sector (NACE rev. 2) (Code)'] == 'C12'])

    df = df[df['Attribute (Code)'] == 'V16110'].append(df[df['Attribute (Code)'] == 'V12150'])

    data = []

    for i in df.index:
        data.append(['EU27_2020', year, df['Value'][i], df['Attribute (Code)'][i], df['Sector (NACE rev. 2) (Code)'][i]])
    df = pd.DataFrame(data, columns = ['geo_code', 'time', 'value', 'type', 'nace_code'])

    df.to_csv('../output_data/headline_indicators/employment_value-added/employment-value-added-raw.csv', index = False)

    data_csv = []

    data_json = {}
    data_json['data'] = []
    data_json_part = {}
    data_json_part['name'] = 'agriculture and food industries'
    data_json_part['y'] = df.query('geo_code == "EU27_2020" & time == @year & nace_code == "A01" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "C10" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "C11" & type == "V16110"')['value'].tolist()[0]
    data_json['data'].append(data_json_part)

    data_csv.append(['EU27_2020', year, data_json_part['y'], 'agriculture_and_food_industries'])

    data_json_part = {}
    data_json_part['name'] = 'forestry and wood-based industries'
    data_json_part['y'] = df.query('geo_code == "EU27_2020" & time == @year & nace_code == "A02" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bC16" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bC17" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bC31" & type == "V16110"')['value'].tolist()[0]
    data_json['data'].append(data_json_part)

    data_csv.append(['EU27_2020', year, data_json_part['y'], 'forestry_and_wood-based_industries'])

    data_json_part = {}
    data_json_part['name'] = 'other bio-based industries'
    data_json_part['y'] = df.query('geo_code == "EU27_2020" & time == @year & nace_code == "A03" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bCHEM" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bD3511" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bFUEL" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bTEXT" & type == "V16110"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "C12" & type == "V16110"')['value'].tolist()[0]
    data_json['data'].append(data_json_part)

    data_csv.append(['EU27_2020', year, data_json_part['y'], 'other_bio-based_industries'])

    with open('../output_data/headline_indicators/employment_value-added/employment.json', 'w', encoding = 'utf-8') as f:
        json.dump(data_json, f, ensure_ascii = False, indent = 4)

    df_csv = pd.DataFrame(data_csv, columns = ['geo_code', 'time', 'value', 'type'])
    df_csv.to_csv('../output_data/headline_indicators/employment_value-added/employment.csv', index = False)


    data_csv = []

    data_json = {}
    data_json['data'] = []
    data_json_part = {}
    data_json_part['name'] = 'agriculture and food industries'
    data_json_part['y'] = df.query('geo_code == "EU27_2020" & time == @year & nace_code == "A01" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "C10" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "C11" & type == "V12150"')['value'].tolist()[0]
    data_json['data'].append(data_json_part)

    data_csv.append(['EU27_2020', year, data_json_part['y'], 'agriculture_and_food_industries'])

    data_json_part = {}
    data_json_part['name'] = 'forestry and wood-based industries'
    data_json_part['y'] = df.query('geo_code == "EU27_2020" & time == @year & nace_code == "A02" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bC16" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bC17" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bC31" & type == "V12150"')['value'].tolist()[0]
    data_json['data'].append(data_json_part)

    data_csv.append(['EU27_2020', year, data_json_part['y'], 'forestry_and_wood-based_industries'])

    data_json_part = {}
    data_json_part['name'] = 'other bio-based industries'
    data_json_part['y'] = df.query('geo_code == "EU27_2020" & time == @year & nace_code == "A03" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bCHEM" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bD3511" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bFUEL" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "bTEXT" & type == "V12150"')['value'].tolist()[0] + df.query('geo_code == "EU27_2020" & time == @year & nace_code == "C12" & type == "V12150"')['value'].tolist()[0]
    data_json['data'].append(data_json_part)

    data_csv.append(['EU27_2020', year, data_json_part['y'], 'other_bio-based_industries'])

    with open('../output_data/headline_indicators/employment_value-added/value-added.json', 'w', encoding = 'utf-8') as f:
        json.dump(data_json, f, ensure_ascii = False, indent = 4)

    df_csv = pd.DataFrame(data_csv, columns = ['geo_code', 'time', 'value', 'type'])
    df_csv.to_csv('../output_data/headline_indicators/employment_value-added/value-added.csv', index = False)



def makeJsonPieAgroecosystems(year):
    df = eurostat.get_data_df('aei_ps_inp', flags=False)
    df = df.query('unit == "PC_AREA"')
    df.rename(columns={r'geo\time': 'geo'}, inplace=True)

    data = []

    for i in df.index:
        if df['geo'][i] == 'EU27_2020':
            data.append([df['geo'][i], year, df[year][i], df['indic_ag'][i]])

    df = pd.DataFrame(data, columns = ['geo_code', 'time', 'value', 'type'])

    df.to_csv('../output_data/headline_indicators/agroecosystems/agroecosystems.csv', index = False)

    data = {}
    data['data'] = []
    for i in df.index:
        data_part = {}
        data_part['name'] = getType(df['type'][i])
        data_part['y'] = df['value'][i]
        data['data'].append(data_part)

    with open('../output_data/headline_indicators/agroecosystems/agroecosystems.json', 'w', encoding = 'utf-8') as f:
        json.dump(data, f, ensure_ascii = False, indent = 4)



def makeJsonLineMarineFisheriesAquaculture(years):
    df = pd.read_excel('../input_data/forests-marine-fisheries-aquaculture.xlsx', sheet_name='fisheries')
    df = df.replace('nodata', np.nan)

    data = []

    for fishing_area in fishing_areas:
        fishing_area_code = getFishingAreaCode(fishing_area)
        column_name = 'Explotation levels (F/FMSY) ' + fishing_area
        for year in years:
            data.append([fishing_area_code, year, df.query('Year == @year')[column_name].tolist()[0], 'exploitation'])

    df = pd.DataFrame(data, columns = ['geo_code', 'time', 'value', 'type'])
    df.to_csv('../output_data/headline_indicators/marine_fisheries_aquaculture/marine-fisheries-aquaculture.csv', index = False)

    data = []

    for fishing_area in fishing_areas:
        data_part = {}
        data_part['name'] = fishing_area
        data_part['data'] = []
        fishing_area_code = getFishingAreaCode(fishing_area)
        for year in years:
            if pd.isnull(df.query('geo_code == @fishing_area_code & time == @year')['value'].tolist()[0]):
                data_part['data'].append(None)
            else:
                data_part['data'].append(df.query('geo_code == @fishing_area_code & time == @year')['value'].tolist()[0])
        data.append(data_part)

    with open('../output_data/headline_indicators/marine_fisheries_aquaculture/marine-fisheries-aquaculture.json', 'w', encoding = 'utf-8') as f:
        json.dump(data, f, ensure_ascii = False, indent = 4)



def makeJsonColumnForests(years):
    df = pd.read_excel('../input_data/forests-marine-fisheries-aquaculture.xlsx', sheet_name='forestry', header=1)

    data = []

    for year in years:
        data.append(['EU28', year, df[float(year)][0], 'felling_rates'])
    df = pd.DataFrame(data, columns = ['geo_code', 'time', 'value', 'type'])

    df.to_csv('../output_data/headline_indicators/forests/forests.csv', index = False)

    data = {}
    data['categories'] = years
    data['data'] = []
    for i in df.index:
        data['data'].append(df['value'][i])

    with open('../output_data/headline_indicators/forests/forests.json', 'w', encoding = 'utf-8') as f:
        json.dump(data, f, ensure_ascii = False, indent = 4)



### OBJECTIVE INDICATORS ###

def makeJsonLine(df, indicator_id, years, column_name, types, representation):
    for type in types:
        data = {}
        data['type'] = type
        data['categories'] = years
        data['series'] = []
        if indicator_id == '2.2.b.2':
            for fishing_area in fishing_areas:
                fishing_area_code = getFishingAreaCode(fishing_area)
                values = df.query('geo_code == @fishing_area_code & type == @type')[column_name]
                series_data = {}
                series_data['name'] = fishing_area
                series_data['data'] = values.tolist()
                if len(data['series']) != 0:
                    series_data['visible'] = False
                data['series'].append(series_data)

        else:
            for geo_category in geo_categories:
                geo_category_code = getGeoCategoryCode(geo_category)
                values = df.query('geo_code == @geo_category_code & type == @type')[column_name]
                if len(values) != 0 and values.isnull().all() == False:
                    series_data = {}
                    if geo_category == 'EU27' or geo_category == '15 European countries':
                        geo_category += '*'
                    series_data['name'] = geo_category;
                    if column_name == 'value_share_calculated':
                        values = values*100
                    series_data['data'] = values.where(pd.notnull(values), None).tolist()
                    if len(data['series']) != 0:
                        series_data['visible'] = False
                    data['series'].append(series_data)

        # print(data)
        # print('\n**********************************************************************\n')

        with open('../output_data/indicators/'+indicator_id+'/'+indicator_id+'-line-'+representation+'-'+type+'.json', 'w', encoding = 'utf-8') as f:
            json.dump(data, f, ensure_ascii = False, indent = 4)



def makeJsonColumn(df, indicator_id, years, types, representation, stacked):
    if stacked == True:
        data = {}
        data['categories'] = []
        data['data'] = []
        for year in years:
            data_year = {}
            data_year['year'] = year
            data_year['series'] = []
            for type in types:
                series_data = {}
                series_data['name'] = getType(type)
                if type == 'ANI':
                    series_data['index'] = 1
                elif type == 'VEG':
                    series_data['index'] = 0
                elif type == 'HIGH_INP':
                    series_data['index'] = 2
                elif type == 'MED_INP':
                    series_data['index'] = 1
                elif type == 'LOW_INP':
                    series_data['index'] = 0
                elif type == 'ene':
                    series_data['index'] = 1
                elif type == 'mat':
                    series_data['index'] = 0
                elif type == 'TPA_KM2':
                    series_data['index'] = 1
                elif type == 'MPA_KM2':
                    series_data['index'] = 0
                elif type == 'GS_FOR':
                    series_data['index'] = 1
                elif type == 'GS_OWL':
                    series_data['index'] = 0

                series_data['data'] = []
                for geo_category in geo_categories:
                    geo_category_code = getGeoCategoryCode(geo_category)
                    if (indicator_id == '2.1.b.9' or indicator_id == '2.1.e.1') and (geo_category_code == 'EU27_2020' or geo_category_code == 'EU28'):
                        continue

                    if len(df.query('geo_code == @geo_category_code')['value'].tolist()) != 0:
                        if geo_category == 'EU27':
                            geo_category += '*'
                        if geo_category not in data['categories']:
                            data['categories'].append(geo_category)

                        if len(df.query('geo_code == @geo_category_code & time == @year & type == @type')['value'].tolist()) == 0:
                            series_data['data'].append(None)
                        elif pd.isnull(df.query('geo_code == @geo_category_code & time == @year & type == @type')['value'].tolist()[0]):
                            series_data['data'].append(None)
                        else:
                            series_data['data'].append(df.query('geo_code == @geo_category_code & time == @year & type == @type')['value'].tolist()[0])
                data_year['series'].append(series_data)
            data['data'].append(data_year)

        # print(data)
        # print('\n**********************************************************************\n')

        with open('../output_data/indicators/'+indicator_id+'/'+indicator_id+'-column-'+representation+'-'+'total.json', 'w', encoding = 'utf-8') as f:
            json.dump(data, f, ensure_ascii = False, indent = 4)
    else:
        for type in types:
            data = {}
            data['categories'] = []
            data['data'] = []
            for year in years:
                data_year = {}
                data_year['year'] = year
                data_year['series'] = []
                series_data = {}
                series_data['name'] = getType(type)
                series_data['data'] = []
                if indicator_id == '2.2.b.2':
                    for fishing_area in fishing_areas:
                        fishing_area_code = getFishingAreaCode(fishing_area)
                        if fishing_area not in data['categories']:
                            data['categories'].append(fishing_area)
                        if len(df.query('geo_code == @fishing_area_code & time == @year & type == @type')['value'].tolist()) == 0:
                            series_data['data'].append(None)
                        else:
                            series_data['data'].append(df.query('geo_code == @fishing_area_code & time == @year & type == @type')['value'].tolist()[0])
                    data_year['series'].append(series_data)
                    data['data'].append(data_year)
                else:
                    for geo_category in geo_categories:
                        geo_category_code = getGeoCategoryCode(geo_category)
                        if (indicator_id == '1.1.a.4' or indicator_id == '2.3.a.2' or indicator_id == '3.1.a.1' or indicator_id == '3.4.a.2' or indicator_id == '3.4.a.3' or indicator_id == '4.1.a.3' or indicator_id == '4.1.a.6' or indicator_id == '5.1.b.1' or indicator_id == '5.1.b.2' or indicator_id == '5.2.a.1') and (geo_category_code == 'EU27_2020' or geo_category_code == 'EU28'):
                            continue

                        if len(df.query('geo_code == @geo_category_code & type == @type')['value'].tolist()) != 0 and df.query('geo_code == @geo_category_code & type == @type')['value'].isnull().all() == False:
                            if geo_category == 'EU27' or geo_category == '15 European countries':
                                geo_category += '*'
                            if geo_category not in data['categories']:
                                data['categories'].append(geo_category)

                            if len(df.query('geo_code == @geo_category_code & time == @year & type == @type')['value'].tolist()) == 0:
                                series_data['data'].append(None)
                            elif pd.isnull(df.query('geo_code == @geo_category_code & time == @year & type == @type')['value'].tolist()[0]):
                                series_data['data'].append(None)
                            else:
                                series_data['data'].append(df.query('geo_code == @geo_category_code & time == @year & type == @type')['value'].tolist()[0])
                    data_year['series'].append(series_data)
                    data['data'].append(data_year)

                # print(data)
                # print('\n**********************************************************************\n')

                with open('../output_data/indicators/'+indicator_id+'/'+indicator_id+'-column-'+representation+'-'+type+'.json', 'w', encoding = 'utf-8') as f:
                    json.dump(data, f, ensure_ascii = False, indent = 4)



def calculateRangeThresholds(values, number_ranges):
    values_length = len(values)
    range_length = int(values_length/number_ranges)
    range_lengths = [range_length]*number_ranges
    remaining_values_length = values_length-(range_length*number_ranges)
    # print(values)
    # print(values_length)
    # print(range_length)
    # print(range_lengths)
    # print(remaining_values_length)
    for i in range(remaining_values_length):
        range_lengths[i] += 1
    # print(range_lengths)
    ranges = []
    range_index_min = 0
    range_index_max = range_lengths[0]
    for i in range(len(range_lengths)):
        ranges.append(values[range_index_min:range_index_max])
        if i != len(range_lengths)-1:
            range_index_min = range_index_max
            range_index_max += range_lengths[i+1]
    # print(ranges)

    range_thresholds = []
    range_thresholds.append(ranges[0][0])
    for i in range(len(ranges)-1):
        if ranges[i][-1] != ranges[i+1][0]:
            range_thresholds.append(ranges[i][-1])
            range_thresholds.append(ranges[i+1][0])
        else:
            move_index = 1
            while ranges[i][0-move_index-1] == ranges[i][0-move_index]:
                move_index += 1
                if move_index == len(ranges[i]):
                    return None
            range_thresholds.append(ranges[i][0-move_index-1])
            range_thresholds.append(ranges[i][0-move_index])
    range_thresholds.append(ranges[len(ranges)-1][-1])

    return range_thresholds



def makeJsonMap(df, indicator_id, years, column_name, types, representation, number_ranges):
    for type in types:
        data = {}
        data['type'] = type

        values = []
        if indicator_id == '2.2.b.2':
            for fishing_area_code in df.geo_code.unique():
                values.extend(df.query('geo_code == @fishing_area_code & type == @type')[column_name].tolist())
        else:
            for geo_category_code in df.geo_code.unique():
                if indicator_id != '2.1.d.1' and (geo_category_code=='EU27_2020' or geo_category_code=='EU28'):
                    continue
                values.extend(df.query('geo_code == @geo_category_code & type == @type')[column_name].dropna().tolist())

        if column_name == 'value_share_calculated':
            values = [x*100 for x in values]

        range_thresholds = None
        number_ranges_decrease_by = 0
        while range_thresholds == None:
            range_thresholds = calculateRangeThresholds(sorted(values), number_ranges-number_ranges_decrease_by)
            number_ranges_decrease_by+=1
        data['range_thresholds'] = range_thresholds

        data['series'] = []
        for year in years:
            data_year = {}
            data_year['year'] = year
            data_year['data'] = {}
            df_part = df.query('time == @year & type == @type')
            for i in df_part.index:
                if indicator_id != '2.1.d.1' and (df_part['geo_code'][i]=='EU27_2020' or df_part['geo_code'][i]=='EU28'):
                    continue

                if pd.isnull(df_part[column_name][i]):
                    data_year['data'][df_part['geo_code'][i]] = None
                else:
                    value = df_part[column_name][i]
                    if column_name == 'value_share_calculated':
                        value = value*100
                    data_year['data'][df_part['geo_code'][i]] = value
            data['series'].append(data_year)

        # print(data)
        # print('\n**********************************************************************\n')

        with open('../output_data/indicators/'+indicator_id+'/'+indicator_id+'-map-'+representation+'-'+type+'.json', 'w', encoding = 'utf-8') as f:
            json.dump(data, f, ensure_ascii = False, indent = 4)



def filterDataFramesEurostat(eurostat_id, indicator_id, years, df) :
    if indicator_id == '1.1.a.1':
        df = df.query('unit == "I10"')
    elif indicator_id == '2.1.d.1' and eurostat_id == 'sdg_15_60':
        df = df.query('comspec == "CO_FARM" | comspec == "CO_FOR"')
        for i in df.index:
            df['comspec'][i] += '_'+df[r'unit\time'][i]
    elif indicator_id == '2.1.d.1' and eurostat_id == 'sdg_15_61':
        for i in df.index:
            df['statinfo'][i] += '_'+df[r'unit\time'][i]
    elif indicator_id == '2.1.e.1':
        df = df.query('areaprot == "TPA_PC" | areaprot == "TPA_KM2" | areaprot == "MPA_KM2"')
    elif indicator_id == '2.2.d.5':
        df = df.query('unit == "PC_AREA"')
    elif indicator_id == '3.1.a.1':
        df = df.query('indic_env == "DMC" & material == "MF1" & unit == "THS_T"')
    elif indicator_id == '3.1.b.1':
        df = df.query('unit == "EUR_KGOE"')
    elif indicator_id == '4.1.a.3':
        df = df.query('airpol == "GHG" & unit == "THS_T" & src_crf == "CRF3"')
        for year in years:
            df[year] = df[year].div(1000)
    elif indicator_id == '4.1.a.6':
        df = df.query('airpol == "GHG" & unit == "THS_T" & src_crf == "CRF4"')
        for year in years:
            df[year] = df[year].div(1000)

    return df



def filterDataFramesFiles(indicator_id, country_column_id, time_column_id, value_column_id, type_column_id, years, df):
    if indicator_id == '2.2.a.1':
        df = df.iloc[:-3]
        df = df.replace('-', np.nan)
    elif indicator_id == '3.1.a.2':
        df = df.query('indicator_short == "Material Footprint (Biomass) per capita" & year >= 2000')
        df = df.loc[df['iso_2'].isin(geo_category_codes_list)]
    elif indicator_id == '3.4.a.4':
        data = []
        types = ['ene', 'mat']
        for type in types:
            for i in df.index:
                data_part = []
                if pd.isnull(df[country_column_id][i]) == False and df[country_column_id][i] != 'unit = %':
                    data_part.append(df[country_column_id][i])
                    for index_year, year in enumerate(years, start=1):
                        if type == 'ene':
                            data_part.append(df['Unnamed: '+str(index_year*2)][i])
                        else:
                            data_part.append(df[year][i])
                    data_part.append(type)
                    data.append(data_part)
        df = pd.DataFrame(data, columns = ['Unnamed: 0', 2009, 2010, 2011, 2012, 2013, 2014, 2015, 'type'])
    elif indicator_id == '5.1.a.2' or indicator_id == '5.1.a.5' or indicator_id == '5.1.b.1' or indicator_id == '5.1.b.2' or indicator_id == '5.2.a.1':
        if indicator_id == '5.1.a.2':
            df_initial = df
            df = df[df['Attribute (Code)'] == 'V12150']
        elif indicator_id == '5.1.a.5':
            df = df[df['Attribute (Code)'] == 'V91110']
        elif indicator_id == '5.1.b.1':
            df = df[df['Attribute (Code)'] == 'V12110']
        elif indicator_id == '5.1.b.2':
            df = df[df['Attribute (Code)'] == 'V12150']
        elif indicator_id == '5.2.a.1':
            df = df[df['Attribute (Code)'] == 'V16110']
        df = df[df[type_column_id] == 'A01'].append(df[df[type_column_id] == 'A02']).append(df[df[type_column_id] == 'A03']).append(df[df[type_column_id] == 'bC13']).append(df[df[type_column_id] == 'bC14']).append(df[df[type_column_id] == 'bC15']).append(df[df[type_column_id] == 'bC16']).append(df[df[type_column_id] == 'bC17']).append(df[df[type_column_id] == 'bC21']).append(df[df[type_column_id] == 'bC22']).append(df[df[type_column_id] == 'bC31']).append(df[df[type_column_id] == 'bchem']).append(df[df[type_column_id] == 'bD3511']).append(df[df[type_column_id] == 'Biod']).append(df[df[type_column_id] == 'Bioeth']).append(df[df[type_column_id] == 'C10']).append(df[df[type_column_id] == 'C11']).append(df[df[type_column_id] == 'C12'])

        if indicator_id == '5.1.a.2':
            for i in df.index:
                denominator = df_initial.loc[(df_initial['Attribute (Code)'] == 'V12150') & (df_initial[country_column_id] == df[country_column_id][i]) & (df_initial[time_column_id] == df[time_column_id][i]) & (df_initial[type_column_id] == 'bTOTC')][value_column_id]
                df[value_column_id][i] = (df[value_column_id][i]/denominator)*100

    for i in df.index:
        if indicator_id != '2.2.b.2':
            df[country_column_id][i] = getGeoCategoryCode(df[country_column_id][i])
        if type_column_id != None:
            df[type_column_id][i] = df[type_column_id][i].replace(' ', '_')

    return df



def reorganizeDataFrames(indicator_id, country_column_id, time_column_id, value_column_id, type_column_id, years, df):
    data = []

    if indicator_id == '1.1.b.1':
        for i in df.index:
            data.append([df[country_column_id][i], df[time_column_id][i], df[value_column_id][i], 'percent'])
    elif indicator_id == '2.2.b.2':
        for i in df.index:
            data.append([df['fishing_area_code'][i], df[time_column_id][i], df[value_column_id][i], 'exploitation'])
    elif indicator_id == '3.1.a.2' or indicator_id == '5.1.a.2' or indicator_id == '5.1.a.5' or indicator_id == '5.1.b.1' or indicator_id == '5.1.b.2' or indicator_id == '5.2.a.1':
        for i in df.index:
            data.append([df[country_column_id][i], df[time_column_id][i], df[value_column_id][i], df[type_column_id][i]])
    elif indicator_id == '2.2.a.1':
        for i in df.index:
            for year in years:
                data.append([df[country_column_id][i], year, df[year][i], 'felling_rates'])
    elif indicator_id == '3.4.a.4':
        for i in df.index:
            for year in years:
                data.append([df[country_column_id][i], year, df[year][i], df['type'][i]])
    else:
        for i in df.index:
            for year in years:
                data.append([df[country_column_id][i], year, df[year][i], df[type_column_id][i]])
    df = pd.DataFrame(data, columns = ['geo_code', 'time', 'value', 'type'])

    return df



def createCsvFiles(eurostat_id, indicator_id, df):
    if indicator_id == '2.1.d.1' and eurostat_id == 'sdg_15_61':
        df.to_csv('../output_data/indicators/2.1.d.1/2.1.d.1.csv', mode='a', header=False, index=False)
        df = pd.read_csv('../output_data/indicators/2.1.d.1/2.1.d.1.csv')
    else:
        df.to_csv('../output_data/indicators/'+indicator_id+'/'+indicator_id+'.csv', index=False)

    return df



def createVisualizationFiles(indicator_id, years, df):
    if indicator_id == '1.1.b.1' or indicator_id == '2.1.b.4' or indicator_id == '2.2.a.1' or indicator_id == '3.1.b.2' or indicator_id == '3.1.c.2' or indicator_id == '4.1.b.3' or indicator_id == '5.1.a.2':
        makeJsonLine(df, indicator_id, years, 'value', df.type.unique(), 'share')
        makeJsonColumn(df, indicator_id, years, df.type.unique(), 'share', False)
        makeJsonMap(df, indicator_id, years, 'value', df.type.unique(), 'share', 6)
    elif indicator_id == '1.1.c.1':
        makeJsonLine(df, indicator_id, years, 'value', df.type.unique(), 'total')
        makeJsonLine(df, indicator_id, years, 'value_share_calculated', ['ANI', 'VEG'], 'share')
        makeJsonColumn(df, indicator_id, years, ['ANI', 'VEG'], 'total', False)
        makeJsonColumn(df, indicator_id, years, ['ANI', 'VEG'], 'total', True)
        makeJsonMap(df, indicator_id, years, 'value', df.type.unique(), 'total', 6)
        makeJsonMap(df, indicator_id, years, 'value_share_calculated', ['ANI', 'VEG'], 'share', 6)
    elif indicator_id == '2.1.b.9':
        makeJsonLine(df, indicator_id, years, 'value', df.type.unique(), 'total')
        makeJsonColumn(df, indicator_id, years, df.type.unique(), 'total', True)
        makeJsonMap(df, indicator_id, years, 'value', df.type.unique(), 'total', 6)
    elif indicator_id == '2.1.d.1':
        years.append(2018)
        makeJsonLine(df, indicator_id, years, 'value', ['CO_FARM_I90', 'CO_FARM_I00', 'CO_FOR_I90', 'CO_FOR_I00'], 'total')
        makeJsonColumn(df, indicator_id, years, ['CO_FARM_I90', 'CO_FARM_I00', 'CO_FOR_I90', 'CO_FOR_I00'], 'total', False)
        makeJsonMap(df, indicator_id, years, 'value', ['CO_FARM_I90', 'CO_FARM_I00', 'CO_FOR_I90', 'CO_FOR_I00'], 'total', 6)
        years.pop()
        makeJsonLine(df, indicator_id, years, 'value', ['SME_I90', 'SME_I00'], 'total')
        makeJsonColumn(df, indicator_id, years, ['SME_I90', 'SME_I00'], 'total', False)
        makeJsonMap(df, indicator_id, years, 'value', ['SME_I90', 'SME_I00'], 'total', 6)
    elif indicator_id == '2.1.e.1':
        makeJsonLine(df, indicator_id, years, 'value', ['TPA_KM2', 'MPA_KM2'], 'total')
        makeJsonLine(df, indicator_id, years, 'value', ['TPA_PC'], 'share')
        makeJsonColumn(df, indicator_id, years, ['TPA_KM2', 'MPA_KM2'], 'total', True)
        makeJsonColumn(df, indicator_id, years, ['TPA_PC'], 'share', False)
        makeJsonMap(df, indicator_id, years, 'value', ['TPA_KM2', 'MPA_KM2'], 'total', 6)
        makeJsonMap(df, indicator_id, years, 'value', ['TPA_PC'], 'share', 6)
    elif indicator_id == '2.2.d.5' or indicator_id == '3.4.a.4':
        makeJsonLine(df, indicator_id, years, 'value', df.type.unique(), 'share')
        makeJsonColumn(df, indicator_id, years, df.type.unique(), 'share', True)
        makeJsonMap(df, indicator_id, years, 'value', df.type.unique(), 'share', 6)
    else:
        makeJsonLine(df, indicator_id, years, 'value', df.type.unique(), 'total')
        makeJsonColumn(df, indicator_id, years, df.type.unique(), 'total', False)
        makeJsonMap(df, indicator_id, years, 'value', df.type.unique(), 'total', 6)



def createFilesFromEurostat(eurostat_id, indicator_id, type_column_id, years, calculate_share):
    df = eurostat.get_data_df(eurostat_id, flags=False)
    df.rename(columns={r'geo\time': 'geo'}, inplace=True)
    df = df.loc[df['geo'].isin(geo_category_codes_list)]

    df = filterDataFramesEurostat(eurostat_id, indicator_id, years, df)

    df = reorganizeDataFrames(indicator_id, 'geo', None, None, type_column_id, years, df)

    if calculate_share == True:
        df['value_share_calculated'] = ''
        for i in df.index:
            geo_category_code = df['geo_code'][i]
            time = df['time'][i]
            denominator = df.query('geo_code == @geo_category_code & time == @time & type == "TOTAL"')['value'].values[0]
            df['value_share_calculated'][i] = df['value'][i]/denominator

    df = createCsvFiles(eurostat_id, indicator_id, df)

    if indicator_id == '2.1.d.1' and eurostat_id == 'sdg_15_60':
        return

    createVisualizationFiles(indicator_id, years, df)



def createFilesFromFiles(indicator_id, country_column_id, time_column_id, value_column_id, type_column_id, years, file_name, sheet_name, header):
    if file_name.split('.')[-1] == 'csv':
        df = pd.read_csv(file_name, header=header)
    else:
        if indicator_id == '2.2.b.2':
            data = []
            for i in range(len(sheet_name)):
                df = pd.read_excel(file_name, sheet_name=sheet_name[i], header=header)
                for j in df.index:
                    data.append([getFishingAreaCode(sheet_name[i]), df[time_column_id][j], df[value_column_id][j]])
            df = pd.DataFrame(data, columns=['fishing_area_code', time_column_id, value_column_id])
        else:
            df = pd.read_excel(file_name, sheet_name=sheet_name, header=header)

    df = filterDataFramesFiles(indicator_id, country_column_id, time_column_id, value_column_id, type_column_id, years, df)

    df = reorganizeDataFrames(indicator_id, country_column_id, time_column_id, value_column_id, type_column_id, years, df)

    df = createCsvFiles(None, indicator_id, df)

    createVisualizationFiles(indicator_id, years, df)



# makeJsonArea([2009, 2010, 2011, 2012, 2013, 2014, 2015])

# makeJsonPieEmploymentValueAdded('2017')

# makeJsonPieAgroecosystems(2017)

# makeJsonLineMarineFisheriesAquaculture([2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018])

# makeJsonColumnForests([1990, 2000, 2005, 2010])

# Agricultural factor income per annual work unit (AWU)
# https://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&language=en&pcode=sdg_02_20&plugin=1
# createFilesFromEurostat('sdg_02_20', '1.1.a.1', 'unit', [2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019], False)

# Total biomass supply for food purposes, including inputs
# createFilesFromFiles('1.1.a.4', 'Geography', None, None, 'Unit', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017], '../input_data/biomass-uses-1.1.a.4.xlsx', '1.1.a.4biomass to food and feed', 0)

# Prevalence of moderate or severe food insecurity in the total population, yearly estimates
# createFilesFromFiles('1.1.b.1', 'geo', 'time', 'Value', None, ['2015', '2016', '2017', '2018'], '../input_data/1.1.b.1.csv', None, 0)

# Daily calorie supply per capita by source
# https://ec.europa.eu/eurostat/tgm/refreshTableAction.do?tab=table&plugin=1&pcode=t2020_rk100&language=en
# createFilesFromEurostat('t2020_rk100', '1.1.c.1', 'fieldid', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016], True)

# Share of organic farming in utilised agricultural area
# https://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&language=en&pcode=sdg_02_40&plugin=1
# createFilesFromEurostat('sdg_02_40', '2.1.b.4', 'unit', [2012, 2013, 2014, 2015, 2016, 2017, 2018], False)

# Forest and other wooded land growing stock
# https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=for_vol&lang=en
# createFilesFromEurostat('for_vol', '2.1.b.9', 'indic_fo', [1990, 2000, 2010, 2015, 2016, 2017, 2018, 2019, 2020], False)

# Bird and butterfly indices EU aggregate (common farmland bird Index, common forest bird index, grassland butterfly index)
# https://ec.europa.eu/eurostat/databrowser/view/sdg_15_60/default/table?lang=en
# https://ec.europa.eu/eurostat/databrowser/view/sdg_15_61/default/table?lang=en
# createFilesFromEurostat('sdg_15_60', '2.1.d.1', 'comspec', [1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018], False)
# createFilesFromEurostat('sdg_15_61', '2.1.d.1', 'statinfo', [1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017], False)

# Surface of marine and terrestrial sites designated under NATURA 2000
# https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=env_bio1&lang=en
# createFilesFromEurostat('env_bio1', '2.1.e.1', 'areaprot', [2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019], False)

# Long term ratio of annual fellings (m3/ha/year) to net annual increment (m3/ha/year)
# createFilesFromFiles('2.2.a.1', 'Country', None, None, None, [1990, 2000, 2005, 2010], '../input_data/2.2.a.1.xlsx', 'Foglio1', 1)

# Fish mortality of commercially exploited fish and shellfish exceeding fishing mortality at maximum sustainable yield
# createFilesFromFiles('2.2.b.2', None, 'Year', 'Explotation levels (F/FMSY)', None, [2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018], '../input_data/2.2.b.2.xlsx', ['NE Atlantic', 'Mediterranean & Black Sea'], 0)

# Intensification of farming (high, medium and low input farms and share of high input farms)
# https://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=aei_ps_inp&lang=en
# createFilesFromEurostat('aei_ps_inp', '2.2.d.5', 'indic_ag', [2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017], False)

# Roundwood removals
# createFilesFromFiles('2.3.a.2', 'Total removals', None, None, 'unit', ['2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018'], '../input_data/2.3.a.2.xlsx', 'trial_output', 0)

# Domestic Material Consumption (Biomass)
# https://appsso.eurostat.ec.europa.eu/nui/show.do?query=BOOKMARK_DS-075779_QID_138D22EA_UID_-3F171EB0&layout=TIME,C,X,0;GEO,L,Y,0;UNIT,L,Z,0;MATERIAL,L,Z,1;INDIC_ENV,L,Z,2;INDICATORS,C,Z,3;&zSelection=DS-075779MATERIAL,MF1;DS-075779INDICATORS,OBS_FLAG;DS-075779INDIC_ENV,DMC;DS-075779UNIT,THS_T;&rankName1=INDIC-ENV_1_2_-1_2&rankName2=MATERIAL_1_2_-1_2&rankName3=UNIT_1_2_-1_2&rankName4=INDICATORS_1_2_-1_2&rankName5=TIME_1_0_0_0&rankName6=GEO_1_2_0_1&sortC=ASC_-1_FIRST&rStp=&cStp=&rDCh=&cDCh=&rDM=true&cDM=true&footnes=false&empty=false&wai=false&time_mode=ROLLING&time_most_recent=true&lang=EN&cfo=%23%23%23%2C%23%23%23.%23%23%23
# createFilesFromEurostat('env_ac_mfa', '3.1.a.1', 'material', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019], False)

# Material Footprint (Biomass)
# https://uneplive.unep.org/media/docs/statistics/indicators/12_2_1.xlsx
# createFilesFromFiles('3.1.a.2', 'country_name', 'year', 'data_value', 'indicator_short', ['2000', '2001', '2002', '2003', '2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2016'], '../input_data/3.1.a.2.xlsx', 'Country Data', 0)

# Energy productivity
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=t2020_rd310&lang=en
# createFilesFromEurostat('t2020_rd310', '3.1.b.1', 'unit', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018], False)

# Share of renewable energy in gross final energy consumption
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=t2020_31&lang=en
# createFilesFromEurostat('t2020_31', '3.1.b.2', 'indic_eu', ['2004', '2005', '2006', '2007', '2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017', '2018'], False)

# Circular material rate
# https://ec.europa.eu/eurostat/tgm/table.do?tab=table&init=1&language=en&pcode=cei_srm030&plugin=1
# createFilesFromEurostat('cei_srm030', '3.1.c.2', 'unit', [2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017], False)

# Total biomass consumed for energy
# createFilesFromFiles('3.4.a.2', 'Geopolitical Entity', None, None, 'Unit', [2009, 2010, 2011, 2012, 2013, 2014, 2015], '../input_data/3.4.a.2-3.4.a.3.xlsx', 'Bioenergy', 0)

# Total biomass consumed for materials
# createFilesFromFiles('3.4.a.3', 'Geopolitical Entity', None, None, 'Unit', [2009, 2010, 2011, 2012, 2013, 2014, 2015], '../input_data/3.4.a.2-3.4.a.3.xlsx', 'Biomaterials consumption', 0)

# Share of woody biomass used for energy
# createFilesFromFiles('3.4.a.4', 'Unnamed: 0', None, None, None, [2009, 2010, 2011, 2012, 2013, 2014, 2015], '../input_data/3.4.a.4.xlsx', 'Foglio1', 0)

# net GHG emissions (emissions and removals) from agriculture
# https://appsso.eurostat.ec.europa.eu/nui/show.do?query=BOOKMARK_DS-089165_QID_-2BA9C99E_UID_-3F171EB0&layout=TIME,C,X,0;GEO,L,Y,0;UNIT,L,Z,0;AIRPOL,L,Z,1;SRC_CRF,L,Z,2;INDICATORS,C,Z,3;
# createFilesFromEurostat('env_air_gge', '4.1.a.3', 'src_crf', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018], False)

# net GHG emissions (emissions and removals) from LULUCF
# https://appsso.eurostat.ec.europa.eu/nui/show.do?query=BOOKMARK_DS-089165_QID_21986B5B_UID_-3F171EB0&layout=TIME,C,X,0;GEO,L,Y,0;UNIT,L,Z,0;AIRPOL,L,Z,1;SRC_CRF,L,Z,2;INDICATORS,C,Z,3;
# createFilesFromEurostat('env_air_gge', '4.1.a.6', 'src_crf', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018], False)

# Water exploitation index (WEI)
# http://appsso.eurostat.ec.europa.eu/nui/show.do?dataset=sdg_06_60&lang=en
# createFilesFromEurostat('sdg_06_60', '4.1.b.3', 'unit', [2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2017], False)

# Value Added per sector / Bioeconomy value added
# createFilesFromFiles('5.1.a.2', 'Country', 'Year', 'Value', 'Sector (NACE rev. 2) (Code)', ['2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017'], '../input_data/5.1.a.2-5.1.b.1-5.1.b.2-5.2.a.1.csv', None, 0)

# Gross value added per person employed in bioeconomy
# createFilesFromFiles('5.1.a.5', 'Country', 'Year', 'Value', 'Sector (NACE rev. 2) (Code)', [2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018], '../input_data/5.1.a.5.csv', None, 0)

# Turnover in bioeconomy per sector
# createFilesFromFiles('5.1.b.1', 'Country', 'Year', 'Value', 'Sector (NACE rev. 2) (Code)', ['2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017'], '../input_data/5.1.a.2-5.1.b.1-5.1.b.2-5.2.a.1.csv', None, 0)

# Value-added per sector
# createFilesFromFiles('5.1.b.2', 'Country', 'Year', 'Value', 'Sector (NACE rev. 2) (Code)', ['2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017'], '../input_data/5.1.a.2-5.1.b.1-5.1.b.2-5.2.a.1.csv', None, 0)

# Persons employed per bioeconomy sectors
# createFilesFromFiles('5.2.a.1', 'Country', 'Year', 'Value', 'Sector (NACE rev. 2) (Code)', ['2008', '2009', '2010', '2011', '2012', '2013', '2014', '2015', '2016', '2017'], '../input_data/5.1.a.2-5.1.b.1-5.1.b.2-5.2.a.1.csv', None, 0)
