import pandas as pd
import json

df = pd.read_excel('../input_data/metadata.xlsx', sheet_name='revisedListJuly2020 OK TO EDIT', usecols='B,C,D,E,F,G,H,I,L,N,O,U,V,AE,AF,AJ,AK,AL,AM,AO,AP')
# with pd.option_context('display.max_rows', None, 'display.max_columns', None):
print(df)

data = {}

for i in df.index:
    metadata_indicator = {}
    indicator_id = df['Unnamed: 1'][i]
    if pd.isnull(indicator_id) == False:
        data[indicator_id] = {}
        data[indicator_id]['name'] = df['Indicators'][i]
        data[indicator_id]['objective_id'] = str(int(df['objectiveid'][i]))
        data[indicator_id]['objective'] = df['objectivename'][i]
        data[indicator_id]['normative_criterion_id'] = str(df['normcrit1d'][i])
        data[indicator_id]['normative_criterion'] = df['normcritname'][i]
        data[indicator_id]['key_component_id'] = str(df['keycompid'][i])
        data[indicator_id]['key_component'] = df['keycompname'][i]
        data[indicator_id]['definition'] = df['definition'][i]
        data[indicator_id]['source'] = df['Source'][i]
        data[indicator_id]['link'] = df['Link'][i]
        data[indicator_id]['geo_coverage'] = df['Geo coverage'][i]
        data[indicator_id]['comparability_geographical'] = df['Comparable across countries'][i]
        data[indicator_id]['frequency'] = df['Frequency'][i]
        data[indicator_id]['timeliness'] = df['Timeliness'][i]
        data[indicator_id]['length_of_time_series'] = df['Length of time series'][i]
        data[indicator_id]['comparability_over_time'] = df['Comparable over time'][i]
        data[indicator_id]['used_elsewhere'] = df['usedElsewhere'][i]
        data[indicator_id]['link_used_elsewhere'] = df['linkUsedElsewhere'][i]
        data[indicator_id]['green_deal_priority'] = df['greendealname'][i]
        data[indicator_id]['sdg_ids'] = df['sdgids'][i]

for indicator_id, indicator_metadata in data.items():
    for k, v in indicator_metadata.items():
        if pd.isnull(v):
            indicator_metadata[k] = None

print(data)
with open('../output_data/metadata/indicators.json', 'w', encoding = 'utf-8') as f:
    json.dump(data, f, ensure_ascii = False, indent = 4)
