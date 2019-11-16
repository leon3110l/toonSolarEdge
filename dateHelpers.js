function addDay(date, days) {
    if(!date) {
        date = new Date()
    }
    if(!days) {
        days = 1
    }

    var ret = new Date(date)
    ret.setDate(ret.getDate() + days)
    return ret
}

function clearTime(date) {
    date.setHours(0, 0, 0, 0)

    return date;
}
function formatTime(date) {
    return date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds()
}
function formatDate(date) {
    return date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()
}
function formatDateTime(date) {
    return formatDate(date) + " " + formatTime(date)
}