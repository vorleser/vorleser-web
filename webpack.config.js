const Webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const postcss = require('postcss');

const webpack = require('webpack')
const extractCSS = new ExtractTextPlugin('[name].css')

module.exports = {
    entry: {
        bundle: "./src/index.tsx",
    },
    output: {
        path: __dirname + "/dist",
        filename: "[name].js",
        publicPath: "/dist"
    },
    resolve: {
        extensions: [".js", ".jsx", ".ts", ".tsx", ".json", ".css"]
    },
    module: {
        rules: [
            {
                test: /\.tsx?/,
                loader: "awesome-typescript-loader",
            },
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
                test: /\.s?css$/,
                loader: extractCSS.extract([
                    {
                        loader: "css-loader",
                        query: {
                            modules: true,
                            sourceMap: true,
                            importLoaders: 1,
                            localIdentName: "[name]--[local]--[hash:base64:8]"
                        }
                    },
                    {
                        loader: "postcss-loader",
                        query: {
                            sourceMap: true
                        }
                    }
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
