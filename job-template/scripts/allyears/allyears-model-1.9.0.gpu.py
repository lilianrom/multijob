from h2oai_client import Client
import matplotlib.pyplot as plt
import pandas as pd
address = 'http://localhost:12345'
username = 'root'
password = 'root'


def _check_datasets(dataset_path):
	datasets = list(map(lambda x: x.key, h2oai.list_datasets(offset=0, limit=100, include_inactive = False).datasets))
	print ("Datasets:  ", datasets)
	for dataset in datasets:
		summary = h2oai.get_dataset_summary(key=dataset)
		name = summary.name
		print("Summary Name: dataset, summary, name, dataset_path.split('/')[-1]: ", dataset, summary, name, /
                dataset_path.split('/')[-1])
		if name == dataset_path.split('/')[-1]:
			print("Success", name, dataset, summary)
			return dataset
	return False




h2oai = Client(address = address, username = username, password = password)
train_path = '/h2o/databackup/allyears.1987.2013.csv'
#test_path = 
#validate_path = 
is_time_series = False
if is_time_series:
	time_col = "[AUTO]"
scorer =  "AUC"
target = 'IsArrDelayed'
is_classification = True
reproducible = True


trainkey = _check_datasets (train_path)
if trainkey is False:
        print (" ")
        print ("Could not locate train dataset:", train_path)
else:
        print ("Located Train Dataset:", train_path, trainkey)


if ( trainkey == False  ):
	print("One or more edatasets could not be located: please run the following command first:")
	print ("  ./dai-env.sh python  airline-database-1.7-1.8.py > airline-database-1.7-1.8.log 2>&1")
	exit()


config_overrides=" " 

#
drop_cols = ['DepTime',
'ArrTime',
'ActualElapsedTime',
'AirTime',
'ArrDelay',
'DepDelay',
'TaxiIn',
'TaxiOut',
'Cancelled',
'CancellationCode',
'Diverted',
'CarrierDelay',
'WeatherDelay',
'NASDelay',
'SecurityDelay',
'LateAircraftDelay',
'IsDepDelayed']





experiment = h2oai.start_experiment_sync(dataset_key = trainkey,
                                         target_col=target,
                                         is_classification=True,
                                         is_time_series = is_time_series, 
                                         time=3,
                                         accuracy=3,
                                         interpretability=5,
                                         scorer=scorer,
                                         enable_gpus=True,
                                         seed=1234,
                                         cols_to_drop=drop_cols, 
										 config_overrides="""
										 autodoc_pd_max_runtime = 0
										 early_stopping = true
										 fixed_num_individuals = 2
										 feature_brain_level = -1
										 enable_tensorflow="off"
										 enable_lightgbm="off"
										 enable_rulefit="off"
										 enable_ftrl="off"
										 enable_glm="on"
										 enable_xgboost_gbm = \"on\" 
										 enable_xgboost_dart = \"off\"
										 enable_decision_tree = "off"
										 enable_constant_model = "off"
										 enable_pytorch = "off"
                                                                                 enable_zero_inflated_models = "off"
										 """
										 )


print ("Experiment", experiment, vars(experiment))
print("Final Model Score on Validation Data: " + str(round(experiment.valid_score, 3)))
#print("Final Model Score on Test Data: " + str(round(experiment.test_score, 3)))

