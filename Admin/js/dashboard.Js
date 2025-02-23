// Graphique Linéaire
var ctx1 = document.getElementById('lineChart').getContext('2d');
new Chart(ctx1, {
    type: 'line',
    data: {
        labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
        datasets: [{
            label: 'Clients',
            data: [15, 20, 30, 40, 45, 60, 70],
            borderColor: 'rgb(75, 192, 192)',
            backgroundColor: 'rgba(75, 192, 192, 0.2)',
            fill: true,
            tension: 0.4,
            borderWidth: 2,
        }]
    },
    options: {
        responsive: true,
        animation: {
            duration: 1000,
        },
        plugins: {
            legend: {
                position: 'top',
            },
        },
    }
});

// Graphique Circulaire
var ctx2 = document.getElementById('pieChart').getContext('2d');
new Chart(ctx2, {
    type: 'pie',
    data: {
        labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven'],
        datasets: [{
            label: 'Clients',
            data: [30, 50, 80, 40, 100],
            backgroundColor: ['#FF5733', '#33FF57', '#3357FF', '#FF33A1', '#FFD933'],
            borderWidth: 1
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                position: 'top',
            },
            tooltip: {
                enabled: true,
            }
        },
        animation: {
            animateRotate: true,
            duration: 1500,
        },
    }
});

// Graphique Histogramme
var ctx3 = document.getElementById('barChart').getContext('2d');
new Chart(ctx3, {
    type: 'bar',
    data: {
        labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil'],
        datasets: [{
            label: 'Clients',
            data: [10, 25, 35, 50, 45, 70, 90],
            backgroundColor: 'rgba(54, 162, 235, 0.2)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1,
        }]
    },
    options: {
        responsive: true,
        animation: {
            duration: 1200,
        },
        plugins: {
            legend: {
                position: 'top',
            },
        },
        scales: {
            y: {
                beginAtZero: true,
            },
        },
    }
});

// Graphique en Aire
var ctx4 = document.getElementById('areaChart').getContext('2d');
new Chart(ctx4, {
    type: 'line',
    data: {
        labels: ['Jan', 'Fév', 'Mar', 'Avr', 'Mai', 'Juin', 'Juil'],
        datasets: [{
            label: 'Interactions',
            data: [60, 50, 40, 20, 20, 30, 40],
            borderColor: 'rgb(255, 99, 132)',
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            fill: true,
            tension: 0.4,
            borderWidth: 2,
        }]
    },
    options: {
        responsive: true,
        animation: {
            duration: 1000,
        },
        plugins: {
            legend: {
                position: 'top',
            },
        },
    }
});