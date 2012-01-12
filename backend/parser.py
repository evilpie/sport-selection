#!/usr/bin/python
# -*- coding: utf-8 -*-
import csv

def parseWahl(file):
    reader = csv.DictReader(file)
    users = []

    for row in reader:
        user = {
            'login': row['Anmeldename'],
            'name': row['Vollständiger Name'],
            'course': row['Mein Schwerpunkt ist'],
            'selection': [
                [row['1. Wahl Q1'], row['2. Wahl Q1']],
                [row['1. Wahl Q2'], row['2. Wahl Q2']]
            ],
            'ski': False
        }

        #adjust if parsing for Ski or Snowboard course changes
        if not 'keinen' in row['Wahl für Q4: Ski- und Snowboard findet statt Ende Q1']:
            user['ski'] = True

        users.append(user)

    return users

def parseKurse(file):
    reader = csv.reader(file)

    map = {}

    for row in reader:
        name, max = row

        map[name] = {
            'name': name,
            'max': int(max),
            'users': []
        }

    return map
    
