from aiohttp import web

async def handle(request):      
    name = request.match_info.get('name', "World! from V2")
    text = "Hello, " + name
    print('received request, replying with "{}".'.format(text))
    return web.Response(text=text)

app = web.Application()
app.router.add_get('/', handle)
app.router.add_get('/{name}', handle)

web.run_app(app, port=8080)