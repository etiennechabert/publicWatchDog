function colorPick(value){
    if (good)
        value = (value - min) / (max - min) * 100;
    else
        value = 100 - (value - min) / (max - min) * 100;
    return $.xcolor.gradientlevel('#4c0000', '#004c00', value, 100);
}

function    cellValue(cell)
{
    cell = $(cell);
    value = cell.attr('data');
    if (value == undefined)
        value = parseFloat(cell.text())
    return value
}

function    colorCell(index, cell){
    cell = $(cell);

    cell.css('background-color', colorPick(cellValue(cell)));
}

function    colorColumn(index, column){
    cellIndex = column.cellIndex;
    column = $(column);
    good = column.attr('good') == 'true';
    cells = $('#' + table_id + ' td:nth-child(' + (cellIndex + 1) + ')');
    cellsValues = cells.map(function(index, e) {return cellValue(e)})
    cellsValues = cellsValues.filter(function(i, e){
        return (e != undefined &&  isNaN(e) == false)
    });
    max = Math.max.apply(null, cellsValues);
    min = Math.min.apply(null, cellsValues);

    column.attr('min', min);
    column.attr('max', max);

    cells.each(colorCell);
}

function    colorTable(index, element){
    element = $(element);
    table_id = element.attr('id');
    if (table_id == undefined)
        return ;
    $('#' + table_id + ' th[color=true]').each(colorColumn);
}

function    colorColumnAverage(index, element){
    element = $(element);
    min = Math.max(element.attr('min'), 0);
    max = element.attr('max');
    value = Math.max(element.attr('value'), 0);
    good = true;
    color = colorPick(value);
    element.css('background-color', color);
}

function    colorTableAverage(index, element){
    element = $(element);
    table_id = element.attr('id');
    if (table_id == undefined)
        return ;
    $('#' + table_id + ' tbody tr').each(colorColumnAverage);
}

function    colorElement(index, element){
    element = $(element);
    min = element.attr('min');
    max = element.attr('max');
    good = true;
    element.css('background-color', colorPick(element.attr('value')))
}
