const path = require("path");
const { CleanWebpackPlugin } = require('clean-webpack-plugin');

module.exports = {
    entry: {
        app: [
            './src/index.js',
        ],
    },

    output: {
        path: path.resolve(__dirname + '/dist'),
        filename: '[name].js',
    },

    module: {
        rules: [
            {
                test: /\.html$/,
                exclude: /node_modules/,
                loader: 'file-loader?name=[name].[ext]',
            },
            {
                test: /\.elm$/,
                exclude: [/elm-stuff/, /node_modules/],
                loader: 'elm-webpack-loader?verbose=true',
            },
        ],

        noParse: /\.elm$/,
    },

    plugins: [
        new CleanWebpackPlugin(),
    ],
    
    devServer: {
        inline: true,
        stats: {colors: true},
    },
};
