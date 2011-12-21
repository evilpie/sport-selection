import datetime
from munkres import Munkres, print_matrix

number_of_choices = 2
Q1 = 0
Q2 = 1

def normalize(user):
    seen = []
    def clean(item):
        if item in seen:
            return None
        else:
            seen.append(item)
            return item

    user['selection'][Q1] = map(clean, user['selection'][Q1])
    user['selection'][Q2] = map(clean, user['selection'][Q2])

    return user

def attach_importance(user):
    def measure(item, index):
        #factor = 1.5 if user['class'] == 13 else 1 :TODO: find out class

        if item is None:
            index = number_of_choices

        return {'name': item, 'importance': number_of_choices - index} 

    for year in user['selection']:
        for index, item in enumerate(year):
            year[index] = measure(item, index)

    return user


def draw(users, year, courses):
    matrix = []
    counter = {}

    """
    We produce the following matrix
        [
         (user1) [ item1, item1, item1, (in fact item1 * item1.count, item2, item2, ... item2.count ],
         (user2)
         (user3)
            .
            .
        ]

    This means the hungarian algorithm is going to find the "lowest cost", where every user hopefully
    one of his choices.

    This algorithm has a very bad worst case complexity O(n^3), and we need to construct an array of
    the size user.count * number of items * item.count.
    This works well when the number of users is < 200 and the number of items < 30.
    """

    for user in users:
        x = []
        for course in courses:
            for _ in range(0, course['max']):
                want = False
                for inner in user['selection'][year]:
                    if inner['name'] == course['name']:
                        x.append(4 - inner['importance']) # higher importance => "lower cost"
                        want = True
                if not want:
                    x.append(10)

        matrix.append(x)

    start = datetime.datetime.now()
    m = Munkres()
    indexes = m.compute(matrix)
    print 'Computation took: ' + str(datetime.datetime.now() - start)

    good = 0
    for row, column in indexes:
        index = 0
        for course in courses:
            index += course['max']
            if column <= index:
                name = course['name']
                break

        if not counter.has_key(name):
            counter[name] = 1
        else:
            counter[name] += 1

        user = users[row] 
        for selection in user['selection'][year]:
            if selection['name'] == name:
                good += 1

        if not user.has_key('result'):
            user['result'] = [None, None]
        user['result'][year] = name

    print '%d of %d got at least one of their choices' % (good, len(users))

