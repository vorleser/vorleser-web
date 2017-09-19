const Webpack = require('webpack');
const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const postcss = require('postcss');

const webpack = require('webpack')
const extractCSS = new ExtractTextPlugin('[name].css')

module.exports = {
    entry: {
        vendors: [ "webpack-material-design-icons" ],
        bundle: "./src/index.tsx",
    },
    output: {
        path: __dirname + "/dist",
        filename: "[name].js",
        publicPath: "/dist"
    },
    resolve: {
        extensions: [".js", ".jsx", ".ts", ".tsx", ".json", ".css"],
        modules: [
            path.resolve("./src"),
            path.resolve("./node_modules")
        ]
    },
    module: {
        rules: [
            {
                test: /\.tsx?/,
                loader: "awesome-typescript-loader",
            },
            {
                test: /\.(jpe?g|png|gif|svg|eot|woff|ttf|svg|woff2)$/,
                loader: "file-loader?name=./fonts/[name].[ext]"
            },
            {
                test: /\.s?css$/,
                use: [
                    "style-loader", // creates style nodes from JS strings
                    {
                        loader: "css-loader", // translates CSS into CommonJS
                        options: {
                            modules: true, // default is false
                            sourceMap: true,
                            importLoaders: 3,
                            localIdentName: "[name]--[local]--[hash:base64:8]"
                        }
                    },
                    {
                        loader: "postcss-loader",
                        options: {
                            sourceMap: true
                        }
                    },
                    {
                        loader: "resolve-url-loader",
                        options: {
                            sourceMap: true
                        }
                    },
                    {
                        loader: "sass-loader", // compiles Sass to CSS
                        options: {
                            sourceMap: true
                        }
                    },
                ]
            },
        ]
    },
    plugins: [
        postcss()
    ],
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
        new webpack.LoaderOptionsPlugin({
            postcss: () => {
                return [
                  /* eslint-disable global-require */
                  require('postcss-cssnext')({
                    features: {
                      customProperties: {
                        variables: reactToolboxVariables,
                      },
                    },
                  }),
                  require('postcss-modules-values'),
                  /* eslint-enable global-require */
                ];
            }
        })
    ]
}
