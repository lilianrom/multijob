from h2oai_client import Client
import matplotlib.pyplot as plt
import pandas as pd
address = 'http://localhost:12345'
username = 'root'
password = 'root'


def _check_datasets(dataset_path):

	datasets = list(map(lambda x: x.key, h2oai.list_datasets(offset=0, limit=100, include_inactive = False).datasets))
	print ("Datasets in the dataase:  ", datasets)
	for dataset in datasets:
		summary = h2oai.get_dataset_summary(key=dataset)
		name = summary.name
		if name == dataset_path.split('/')[-1]:
			print("Success", name, dataset, summary)
			return dataset
	return False


h2oai = Client(address = address, username = username, password = password)
train_path = '/data/allyears.1987.2013.csv'
target = 'IsArrDelayed'
scorer =  "AUC"
reproducible = True

trainkey = _check_datasets (train_path)
if trainkey is False:
	train = h2oai.create_dataset_sync(train_path)
	print (" ")
	print ("New train dataset is created", train_path, train.key)
else:
	print ("Train Dataset is already loaded:", train_path, trainkey)	


#testkey = _check_datasets (test_path)
#if testkey is False:
#	test = h2oai.create_dataset_sync(test_path)
#	print (" ")
#	print ("New test  dataset is created", test_path, test.key)
#else:
#	print ("Test  Dataset is already loaded:",  test_path, testkey)	


#validkey = _check_datasets (validate_path)
#if validkey is False:
#	test = h2oai.create_dataset_sync(validate_path)
#	print (" ")
#	print ("New validate dataset is created", validate_path, valid.key)
#else:
#	print ("Validate dataset is already loaded:",  validate_path,  validkey)	
#
