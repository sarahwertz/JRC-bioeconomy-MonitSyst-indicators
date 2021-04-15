import pandas as pd
import json

df = pd.read_excel('../input_data/metadata.xlsx', sheet_name='revisedListJuly2020 OK TO EDIT', usecols='B,C,D,E,F,G,H,I,W,X')
with pd.option_context('display.max_rows', None, 'display.max_columns', None):
    print(df)

data = {}
data['objectives'] = []

for i in df.index:
    exists = False
    for j in range(len(data['objectives'])):
        if data['objectives'][j]['id'] == str(df['objectiveid'][i]).split('.')[0]:
            exists = True
    if pd.isnull(df['objectiveid'][i]) != True and exists == False:
        data_objective = {}
        data_objective['id'] = str(df['objectiveid'][i]).split('.')[0]
        data_objective['name'] = df['objectivename'][i]
        if data_objective['name'] == 'Reducing dependence on non-renewable unsustainable resources, whether sourced domestically or from abroad':
            data_objective['name'] = 'Reducing Dependence on Non-renewable Unsustainable Resources'
        elif data_objective['name'] == 'Mitigating and adapting to climate change':
            data_objective['name'] = 'Mitigating and Adapting to Climate Change'
        elif data_objective['name'] == 'Strengthening European competitiveness and creating jobs':
            data_objective['name'] = 'Strengthening European Competitiveness and Creating Jobs'
        data_objective['normative_criteria'] = []
        data['objectives'].append(data_objective)

for j in range(len(data['objectives'])):
    for i in df.index:
        exists = False
        for k in range(len(data['objectives'][j]['normative_criteria'])):
            if data['objectives'][j]['normative_criteria'][k]['id'] == str(df['normcrit1d'][i]):
                exists = True
        if str(df['normcrit1d'][i]).split('.')[0] == data['objectives'][j]['id'] and exists == False:
            data_normative_criterion = {}
            data_normative_criterion['id'] = str(df['normcrit1d'][i])
            data_normative_criterion['name'] = df['normcritname'][i]
            data_normative_criterion['key_components'] = []
            data['objectives'][j]['normative_criteria'].append(data_normative_criterion)

for j in range(len(data['objectives'])):
    for k in range(len(data['objectives'][j]['normative_criteria'])):
        for i in df.index:
            exists = False
            for m in range(len(data['objectives'][j]['normative_criteria'][k]['key_components'])):
                if data['objectives'][j]['normative_criteria'][k]['key_components'][m]['id'] == str(df['keycompid'][i]):
                    exists = True
            if pd.isnull(df['keycompid'][i]) != True and str(df['keycompid'][i]).split('.')[0]+'.'+str(df['keycompid'][i]).split('.')[1] == data['objectives'][j]['normative_criteria'][k]['id'] and exists == False:
                data_key_component = {}
                data_key_component['id'] = str(df['keycompid'][i])
                data_key_component['name'] = df['keycompname'][i]
                data_key_component['indicators'] = []
                data['objectives'][j]['normative_criteria'][k]['key_components'].append(data_key_component)

for j in range(len(data['objectives'])):
    for k in range(len(data['objectives'][j]['normative_criteria'])):
        for m in range(len(data['objectives'][j]['normative_criteria'][k]['key_components'])):
            for i in df.index:
                if pd.isnull(df['Unnamed: 1'][i]) != True and str(df['Unnamed: 1'][i]).split('.')[0]+'.'+str(df['Unnamed: 1'][i]).split('.')[1]+'.'+str(df['Unnamed: 1'][i]).split('.')[2] == data['objectives'][j]['normative_criteria'][k]['key_components'][m]['id']:
                    data_indicator = {}
                    data_indicator['id'] = str(df['Unnamed: 1'][i])
                    data_indicator['name'] = df['Indicators'][i]
                    data_indicator['value_chain_step'] = df['ValChainStep'][i]
                    if data_indicator['value_chain_step'] == 'PrimarySectors':
                        data_indicator['value_chain_step'] = 'Primary sectors'
                    elif data_indicator['value_chain_step'] == 'ManufServices':
                        data_indicator['value_chain_step'] = 'Manufacturing sectors'
                    elif data_indicator['value_chain_step'] == 'DispCascRecyReus':
                        data_indicator['value_chain_step'] = 'Disposal, Cascading, Recycling, Reuse'
                    elif data_indicator['value_chain_step'] == 'wholeChain':
                        data_indicator['value_chain_step'] = 'Whole value chain'

                    data_indicator['primary_production_sector'] = df['primaryProductionSector'][i]
                    if data_indicator['primary_production_sector']  == 'Agric':
                        data_indicator['primary_production_sector'] = 'Agriculture'
                    elif data_indicator['primary_production_sector']  == 'Forest':
                        data_indicator['primary_production_sector'] = 'Forestry'
                    elif data_indicator['primary_production_sector']  == 'Fish':
                        data_indicator['primary_production_sector'] = 'Fisheries and aquaculture'
                    elif data_indicator['primary_production_sector']  == 'AllLand(Agri;For)':
                        data_indicator['primary_production_sector'] = 'All land (agriculture and forestry)'
                    elif data_indicator['primary_production_sector']  == 'AllWater(fish;algae)':
                        data_indicator['primary_production_sector'] = 'All water (fisheries, aquaculture and algae)'
                    elif data_indicator['primary_production_sector']  == 'AgriWater(agri;fish;algae)':
                        data_indicator['primary_production_sector'] = 'Agriculture, fisheries, aquaculture and algae'
                    elif data_indicator['primary_production_sector']  == 'NodistinctionPossible':
                        data_indicator['primary_production_sector'] = 'No distinction possible'
                    elif data_indicator['primary_production_sector']  == 'PossibleToDifferentiateBySector':
                        data_indicator['primary_production_sector'] = 'Possible to distinguish by sector'
                    elif pd.isnull(data_indicator['primary_production_sector']):
                        data_indicator['primary_production_sector'] = 'not applicable'

                    data['objectives'][j]['normative_criteria'][k]['key_components'][m]['indicators'].append(data_indicator)

print(data)
with open('../output_data/metadata/filters.json', 'w', encoding = 'utf-8') as f:
    json.dump(data, f, ensure_ascii = False, indent = 4)
