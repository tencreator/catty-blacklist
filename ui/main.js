$(()=>{
    $('#container').hide()

    window.addEventListener('message', (event)=>{
        console.log(JSON.stringify(event.data))
        if (!event.data) return console.log('No data')
        
        console.log(event.data.type)

        if (event.data.type === 'open') {
            $('#container').show()
        } else if (event.data.type === 'close') {
            $('#container').hide()
        } else if (event.data.type === 'loadList') {
            list = event.data.list || []
            $('#list').empty()
            $('#list-title').text(event.data.title)
            list.forEach((item)=>{
                $('#list').append(`<ul><button onclick="loadBlacklistedItem(${item.id}, '${event.data.title.toUpperCase()}')"><div class="list-item" data-id="${item.id}">${item.name}</div></button></ul>`)
            })
        } else if (event.data.type === 'loadBlacklistedItem') {
            $('#edit-title').text('Editing ' + event.data.item.name)
        }
    })

    $('#close').click(()=>{
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}))
    })

    document.addEventListener('keydown', (event)=>{
        if (event.key === 'Escape') {
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}))
        }
    })
})

function switchList(switchto) {
    const title = switchto.charAt(0).toUpperCase() + switchto.slice(1) + ' - Loading...'
    $('#list-title').text(title)
    $('#list').empty()
    $.post(`https://${GetParentResourceName()}/switchList`, JSON.stringify({list: switchto}))
}

function loadBlacklistedItem(id, list) {
    console.log(id, list)
    $.post(`https://${GetParentResourceName()}/loadBlacklistedItem`, JSON.stringify({id: id, list: list}))
}