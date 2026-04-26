class_name LibraryCard
extends Control

func processModel(data):
    for i in data:
        %Model.processModification(i)
