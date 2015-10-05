
def urlparse(params):

    query  = [p+'='+v if v else p for p,v in params.items()]
    return '?' + '&'.join(query)
    