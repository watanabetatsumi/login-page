package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb"
	"github.com/aws/aws-sdk-go-v2/service/dynamodb/types"
	"github.com/gin-gonic/gin"
)

var jwtSecret = []byte("your_secret_key") // 秘密鍵（環境変数で管理するのがベスト）

func GenerateJWT()

type RequestDate struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

func StartSession() {
	// 1. SessionIDを生成
	// 2. user_idとSessionIDをDBに保存。
	// 3. GenerateJWT()
}

func main() {
	// AWS 設定のロード（EC2のIAMロールを自動認識）
	cfg, err := config.LoadDefaultConfig(context.TODO())
	if err != nil {
		log.Fatalf("AWS設定のロードに失敗: %v", err)
	}

	// DynamoDB クライアント作成
	svc := dynamodb.NewFromConfig(cfg)

	// routerを初期化
	r := gin.Default()

	// GET
	r.GET("/hello", func(c *gin.Context) {
		// map[string]interface{}とすることでJOSNを表現している。
		c.JSON(http.StatusOK, map[string]interface{}{
			"message": "Hello, world",
		})
	})

	// POSTリクエスト（ログイン処理）
	r.POST("/signin", func(c *gin.Context) {
		var reqData RequestDate

		// 送られてきたjsonをデコードしてRequestData構造体にマッピングする
		err := json.NewDecoder(r.Body).Decode(&reqData)
		if err != nil {
			// 400 Bad Request を返す
			c.JSON(http.StatusBadRequest, map[string]interface{}{
				"error":   true,
				"message": "Invalid request body",
			})
		}

		// string型のキー、AttributeValue型の値を持ったマップ
		// types.AttributeValue型(interface型)はAmazon DynamoDB特有のデータ型
		user := map[string]types.AttributeValue{
			"Email":    &types.AttributeValueMemberN{Value: reqData.Email},
			"Password": &types.AttributeValueMemberN{Value: reqData.Password},
		}

		result, err := svc.GetItem(context.TODO(), &dynamodb.GetItemInput{
			TableName: aws.String("Users"),
			Key:       user,
		})

		if err != nil {
			log.Fatalf("DynamoDBのデータ取得に失敗: %v", err)

			// 400 Bad Request を返す
			c.JSON(http.StatusBadRequest, map[string]interface{}{
				"error":   true,
				"message": "Can not Connect to DynamoDB",
			})
		}

		if result.Item == nil {
			fmt.Println("データが見つかりません")

			// 400 Bad Request を返す
			c.JSON(http.StatusBadRequest, map[string]interface{}{
				"error":   true,
				"message": "User Not Found",
			})

		} else {
			// JWTトークンを発行
			sessionid := StartSession()
		}

	})

}
