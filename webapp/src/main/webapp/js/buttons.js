
/**************************/
/* COPY DOWNLOAD BUTTONS */
/*************************/

const copyButtons = document.querySelectorAll('.copy-button');

// Función para copiar texto al portapapeles
function copyToClipboard(text) {
    const el = document.createElement('textarea');
    el.value = text;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
}


// Agregar eventos de clic a los botones de copia
copyButtons.forEach(button => {
    button.addEventListener('click', () => {
        const noteId = button.getAttribute('id');
        copyToClipboard(`${baseUrl}/notes/${noteId.slice(0, -2)}`);
    });
});

