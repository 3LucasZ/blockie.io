myDict = {
    3: {
        'data': 'gibbles'
    },
    4: {
        'data': 'hey'
    }
}
myDict.update(
    {
        3: {
            'data': 'jibber'
        },
        7: {
            'data': 'heyyy'
        }
    }
)
print(myDict)