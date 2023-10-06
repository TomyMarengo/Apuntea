// Selecciona las pestañas y el contenido de las pestañas
var tabLinks = document.querySelectorAll('.nav-link');
var tabContents = document.querySelectorAll('.tab-pane');

// Agrega un evento de clic a cada pestaña
tabLinks.forEach(function(tabLink, index) {
    tabLink.addEventListener('click', function(event) {
        // Previene el comportamiento predeterminado del enlace
        event.preventDefault();

        // Oculta todos los contenidos de las pestañas
        tabContents.forEach(function(tabContent) {
            tabContent.classList.remove('show', 'active');
        });

        // Muestra el contenido de la pestaña correspondiente
        tabContents[index].classList.add('show', 'active');

        // Quita la clase activa de todas las pestañas
        tabLinks.forEach(function(link) {
            link.classList.remove('active');
        });

        // Agrega la clase activa a la pestaña clicada
        tabLink.classList.add('active');
    });
});
