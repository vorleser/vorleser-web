const Webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const postcss = require('postcss');

const extractCSS = new ExtractTextPlugin('[name].css')

module.exports = {
    entry: "./src/index.tsx",
    output: {
        path: __dirname + "/dist",
        filename: "bundle.js",
        publicPath: "/dist"
    },
    resolve: {
        extensions: [".js", ".jsx", ".ts", ".tsx", ".json"]
    },
    module: {
        rules: [
            {
                test: /\.(jpe?g|png|gif|svg|eot|woff|ttf|svg|woff2)$/,
                use: [
                    {
                        loader: "file-loader",
                        options: {
                            hash: "sha512",
                            digest: "hex",
                            name: "[hash].[ext]"
                        }
                    }
                ]
            },
            {
                test: /\.tsx?/,
                loader: "awesome-typescript-loader",
            },
            {
                test: /\.s?css$/,
                loader: extractCSS.extract([
                    {
                        loader: "css-loader",
                        query: {
                            sourceMap: true,
                            importLoaders: 1,
                            localIdentName: "[name]--[local]--[hash:base64:8]"
                        }
                    },
                ])
            },
        ]
    },
    devtool: "source-map",
    devServer: {
        port: 3000,
        historyApiFallback: {
            rewrites: [
                { from: /./, to: '/' }
            ]
        }
    },
    plugins: [
        extractCSS
    ]
}
