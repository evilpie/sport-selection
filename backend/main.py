#!/usr/bin/python
# -*- coding: utf-8 -*-
import parser
import logic
import json

users = parser.parseWahl(open('feedback.csv', 'r'))
courses = {
    'E: Tennis': {'name': 'E: Tennis', 'max': 10, 'users': [] },
    'L: Orientierungslauf': {'name': 'L: Orientierungslauf', 'max': 10, 'users': [] },
    'E: Schwimmen': {'name': 'E: Schwimmen', 'max': 10, 'users': [] },
    'M: Hockey': {'name': 'M: Hockey', 'max': 10, 'users': [] },
    'E: Tischtennis': {'name': 'E: Tischtennis', 'max': 10, 'users': [] },
    'L: Radfahren': {'name': 'L: Radfahren', 'max': 10, 'users': [] },
    'E: Leichtathletik': {'name': 'E: Leichtathletik', 'max': 10, 'users': [] },
    'E: Trampolinturnen': {'name': 'E: Trampolinturnen', 'max': 10, 'users': [] },
    'M: Basketball': {'name': 'M: Basketball', 'max': 10, 'users': [] },
    'M: Flagfootball': {'name': 'M: Flagfootball', 'max': 10, 'users': [] },
    'M: Handball': {'name': 'M: Handball', 'max': 10, 'users': [] },
    'E: Squash': {'name': 'E: Squash', 'max': 10, 'users': [] },
    'E: Geräteturnen': {'name': 'E: Geräteturnen', 'max': 10, 'users': [] },
    'L: Inline-Skating': {'name': 'L: Inline-Skating', 'max': 10, 'users': [] },
    'L: Jogging': {'name': 'L: Jogging', 'max': 10, 'users': [] },
    'L: Triathlon': {'name': 'L: Triathlon', 'max': 10, 'users': [] },
    'M: Rudern': {'name': 'M: Rudern', 'max': 10, 'users': [] },
    'M: Volleyball': {'name': 'M: Volleyball', 'max': 10, 'users': [] },
    'E: Judo': {'name': 'E: Judo', 'max': 10, 'users': [] },
    'L: Klettern': {'name': 'L: Klettern', 'max': 10, 'users': [] },
    'E: Badminton': {'name': 'E: Badminton', 'max': 10, 'users': [] },
    'L: Segeln': {'name': 'L: Segeln', 'max': 10, 'users': [] },
    'M: Fußball': {'name': 'M: Fußball', 'max': 10, 'users': [] }
}

def process(user):
    return logic.attach_importance(logic.normalize(user))

users = map(process, users)

print 'Users: %d Courses: %d' % (len(users), len(courses.values()))
print 'Begin selection process ... (This may take a while)'

logic.draw(users, logic.Q1, list(courses.values()))

for user in users:
    print user['name']
    print '  Wanted: ',
    for selection in user['selection'][logic.Q1]:
        print selection['name'],
    print '\n  Got: ' + user['result'][logic.Q1] + '\n'
    
json.dump(users, open('output.json', 'w'))
