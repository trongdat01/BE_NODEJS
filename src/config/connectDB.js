const { Sequelize } = require('sequelize');

// Option 3: Passing parameters separately (other dialects)
const sequelize = new Sequelize('datpham', 'root', null, {
    host: 'localhost',
    dialect: 'mysql' // 'mysql' | 'mariadb' | 'postgres' | 'mssql'	
});


let connectDB = () => {
    try {
        sequelize.authenticate();
        console.log('Connection has been established successfully.');
    } catch (error) {
        console.error('Unable to connect to the database:', error);
    }
}
module.exports = connectDB;